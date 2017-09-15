//
//  XYAdminMainViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAdminMainViewController.h"
#import "XYNoticeListViewController.h"
#import "XYBonusListViewController.h"
#import "XYNoticeDetailViewController.h"
#import "XYAttendenceViewController.h"
#import "XYLocationManagerWithTimer.h"
#import "XYRankViewController.h"
#import "XYTopNewsCell.h"
#import "XYAdminMainCell.h"
#import "NSDate+DateTools.h"
#import "XYAPPSingleton.h"
#import "AppDelegate.H"
#import "XYAPPSingleton.h"
#import "UIButton+Badge.h"
#import "HttpCache.h"
#import "Harpy.h"


@interface XYAdminMainViewController ()<UITableViewDataSource,UITableViewDelegate,XYRankViewDelegate>
//主界面
@property(strong,nonatomic) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
//今天日期
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthYearLabel;
@property (weak, nonatomic) IBOutlet UIImageView *todayBackgroundView;
//今日数据
@property (weak, nonatomic) IBOutlet UILabel *todayCompleteOrdersLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayBonusLable;
@property (weak, nonatomic) IBOutlet UIView *deviderLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
//工作状态
@property (weak, nonatomic) IBOutlet UIButton *workButton;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
//公告
@property (weak, nonatomic) IBOutlet UIButton *noticeButton;

//data
@property (strong,nonatomic) XYNewsDto* topNews;
@property (strong,nonatomic) XYRankDto* myRank;
@property (strong,nonatomic) NSTimer* onlineTimer;
@property (assign,nonatomic) BOOL hasNewLeaveRecord;

@end

@implementation XYAdminMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getMyRank];//第一次请求我的排名
    
    /**
     *   开关
     */
#warning 线上环境开启，审核时location设为0
    [self setupSwitchConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

    //状态栏动画过渡
    [self.navigationController setNavigationBarHidden:true animated: (!self.isFromTabSelection) && true];
    if (self.isFromTabSelection) {
        //降低排名请求频次
        [self getMyRank];
    }
    self.isFromTabSelection = false;
    //更新日期展示
    [self reloadDateDisplay];
    //实时数据更新
    [self getTopNews];
    //计时和状态
    if ((![XYAPPSingleton sharedInstance].workerStatus) || //没有工作状态
        (([XYAPPSingleton sharedInstance].workerStatus.status!=XYWorkerStatusOffWork) && (![XYAPPSingleton sharedInstance].workerStatus.isToday)) ||//没下班却已过新的一天
        ![[XYAPPSingleton sharedInstance].workerStatus.Id isEqualToString:[XYAPPSingleton sharedInstance].currentUser.Id]){//新用户登录
        [XYAPPSingleton sharedInstance].workerStatus = nil;
        [self getWorkerStatus];//要获取最新状态
    }
}

- (void)viewWillDisappear:(BOOL)animated{
   [super viewWillDisappear:animated];
   [self.navigationController setNavigationBarHidden:false animated:true];
}

- (void)setupSwitchConfiguration {
    [[XYAPIService shareInstance] getSwitchConfiguration:^(XYConfigDto *config) {
        [XYConfigParamUtil save:config];
        //检查版本更新
        [self setupVersionUpdate];
    } errorString:^(NSString *err) {}];
}

- (void)setupVersionUpdate{
    
    [[Harpy sharedInstance] setPresentingViewController:[UIApplication sharedApplication].keyWindow. rootViewController];
    
    if ([XYConfigParamUtil xy_config].update_forced) {
        [[Harpy sharedInstance] setAlertType:HarpyAlertTypeForce];
    }else {
        [[Harpy sharedInstance] setAlertType:HarpyAlertTypeOption];
    }
    
    [[Harpy sharedInstance] setForceLanguageLocalization:HarpyLanguageChineseSimplified];
    [[Harpy sharedInstance] setDebugEnabled:true];
    [[Harpy sharedInstance] checkVersion];
}

#pragma mark - initialize

- (void)initializeUIElements{
    self.lineHeight.constant = LINE_HEIGHT;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setTableHeaderView:self.headerView];
    [self.tableView setTableFooterView:self.footerView];
    self.tableView.separatorColor = XY_COLOR(244, 246, 247);
    [self.tableView addSubview:self.refreshControl];
    [XYAdminMainCell xy_registerTableView:self.tableView identifier:[XYAdminMainCell defaultReuseId]];
    [XYTopNewsCell xy_registerTableView:self.tableView identifier:[XYTopNewsCell defaultReuseId]];
    self.todayBackgroundView.image = [[UIImage imageNamed:@"home_date_bg"]stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [self.workButton setBackgroundImage:[[UIImage imageNamed:@"btn_start_working"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.workButton setTitleEdgeInsets:UIEdgeInsetsMake(16,0,23,0)];
    self.monthYearLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
    self.deviderLine.backgroundColor = [UIColor colorWithWhite:1 alpha:0.15];
}

#pragma mark - property

- (UIRefreshControl*)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - action

- (void)showNewsList{
    
    BOOL hasNewsListInStack = false;
    for(UIViewController* vc in self.navigationController.viewControllers){
        if ([vc isKindOfClass:[XYNoticeListViewController class]]) {
            [self.navigationController popToViewController:vc animated:false];
            [((XYNoticeListViewController*)vc) refreshNoticeList];
            hasNewsListInStack = true;
            break;
        }
    }
    if (!hasNewsListInStack) {
        XYNoticeListViewController* noticeListController = [[XYNoticeListViewController alloc]init];
        [self.navigationController pushViewController:noticeListController animated:false];
    }
    
}

- (void)showRedSpotOnNews{
    //红点
    //self.noticeButton //
    self.noticeButton.badgeValue = @" ";
    self.noticeButton.badgeBGColor = [UIColor redColor];
}

- (void)showRedSpotOnAttendance{
    self.hasNewLeaveRecord = true;
    [self.tableView reloadData];
}

- (void)goToAttendanceView{
    
    self.hasNewLeaveRecord = false;
    
    BOOL hasNewsListInStack = false;
    for(UIViewController* vc in self.navigationController.viewControllers){
        if ([vc isKindOfClass:[XYAttendenceViewController class]]) {
            [self.navigationController popToViewController:vc animated:false];
            [((XYAttendenceViewController*)vc) refreshLeaveList];
            hasNewsListInStack = true;
            break;
        }
    }
    if (!hasNewsListInStack) {
        XYAttendenceViewController* noticeListController = [[XYAttendenceViewController alloc]init];
        [self.navigationController pushViewController:noticeListController animated:false];
    }
}

- (void)refreshView{
    [self getMyRank];
    [self reloadDateDisplay];
    [self getTopNews];
    [self getWorkerStatus];

    
    
//    CocoaSecurityResult *aesData = [CocoaSecurity aesEncrypt:data hexKey:@"aaaaaaaaaaaaaaaa" hexIv:@"aaaaaaaaaaaaaaaa"];
//    CocoaSecurityResult *aesData1 = [CocoaSecurity aesEncrypt:@"kelp"
//                       hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
//                        hexIv:@"CC0A69779E15780 ADAE46C45EB451A23"];
//    CocoaSecurityResult *aesData1 = [CocoaSecurity aesEncrypt:@"aaaa"
//                                                       hexKey:@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
//                                                        hexIv:@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"];
    
//    NSLog(@"aesData+%@", aesData1.hex);
//    NSString *aesPassword2 = [NSString AES128CBC_PKCS5Padding_EncryptStrig:@"a=123&b=456&c=789&time=123456789&sign=53ad947269299bbb289ca9f3740993ba9b1d28f394f4c737a97d3302345e09b5"
//                                                                       key:@"p1^K&N^%I3ABRu*#"
//                                                                        iv:@"1qKMy5XtkpDuj!#f"];
//     NSLog(@"aesData+%@", aesPassword2);
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.topNews?1:0;//置顶公告
        case 1:
            return 2;
        default:
            break;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [XYTopNewsCell defaultHeight];
        case 1:
            return [XYAdminMainCell defaultHeight];
        default:
            break;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (self.topNews) {
            XYTopNewsCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYTopNewsCell defaultReuseId]];
            [cell setContent:self.topNews.title];
            return cell;
        }else{
            return [[UITableViewCell alloc]init];
        }
    }else if(indexPath.section == 1){
        XYAdminMainCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYAdminMainCell defaultReuseId]];
        if (indexPath.row == 0) {
            [cell configCell:true];
            [cell setRankNumber:self.myRank.key];
        }else{
            [cell configCell:false];
            cell.redSpotView.hidden = !self.hasNewLeaveRecord;
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        XYNoticeDetailViewController* noticeDetailController = [[XYNoticeDetailViewController alloc]init];
        noticeDetailController.noticeId = self.topNews.id;
        noticeDetailController.linkUrl = self.topNews.link;
        noticeDetailController.view_count = self.topNews.view_count;
        [self.navigationController pushViewController:noticeDetailController animated:true];
    }else if (indexPath.section == 1) {
        //如果为加盟商工程师，禁止点击
        if ([XYAPPSingleton sharedInstance].currentUser.franchisee) {
            return;
        }
        if (indexPath.row == 0) {
            XYRankViewController* rankController = [[XYRankViewController alloc]init];
            rankController.delegate = self;
            [self.navigationController pushViewController:rankController animated:true];
        }else{
            [self goToAttendanceView];
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:(indexPath.section == 0)? UIEdgeInsetsZero:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:(indexPath.section == 0)? UIEdgeInsetsZero:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

#pragma mark - property 

- (void)setMyRank:(XYRankDto *)myRank{
    _myRank = myRank;
    self.todayBonusLable.text = [NSString stringWithFormat:@"￥%@",@(myRank.push_money)];
    self.todayCompleteOrdersLabel.text = [NSString stringWithFormat:@"%@",@(myRank.order_num)];
    [self.tableView reloadData];
}

#pragma mark - request

- (void)getTopNews{
    //获取置顶公告
    __weak typeof(self) weakself = self;
   [[XYAPIService shareInstance]getTopNews:^(XYNewsDto *topNews) {
       [weakself.refreshControl endRefreshing];
       weakself.topNews = topNews;
       [weakself.tableView reloadData];
   } errorString:^(NSString *error) {
       //不提示
       [weakself.refreshControl endRefreshing];
   }];
}

- (void)getMyRank{
    //获取我的排名等信息
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getMyRank:^(XYRankDto *myRank) {
        [weakself.refreshControl endRefreshing];
        weakself.myRank = myRank;
    } errorString:^(NSString *error) {
        //不提示
        [weakself.refreshControl endRefreshing];
    }];
}

- (void)getWorkerStatus{//更新工人状态
   __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getWorkerStatus:^(XYWorkerStatusDto *workerStatus) {
        [weakself.refreshControl endRefreshing];
        [XYAPPSingleton sharedInstance].workerStatus = workerStatus;
        if (workerStatus.status == XYWorkerStatusInvalid) {
            [weakself showToast:@"您的账号已封停,退出登录"];
            [weakself performSelector:@selector(logOut) withObject:nil afterDelay:2.0];
        }else{
            [weakself updateStatusAndTimer]; 
        }
    } errorString:^(NSString *error) {
        [weakself.refreshControl endRefreshing];
        [weakself showToast:error];
    }];
}

- (void)changeWorkingStatusInto:(BOOL)isWorking{
    
   __weak typeof(self) weakself = self;
    [self showLoadingMask];
    [[XYLocationManagerWithTimer sharedManager].locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if ((!regeocode.formattedAddress) || regeocode.formattedAddress.length == 0) {
            //没有定位成功
            [weakself hideLoadingMask];
            //检测定位-开关
            if([XYConfigParamUtil xy_config].location == 0){
                return;
            }
            [UIAlertView showAlertWithTitle:@"请求失败" message:[NSString stringWithFormat:@"请检查您的设备定位功能后重试。%@",error.localizedFailureReason?[NSString stringWithFormat:@"（%@）",error.localizedFailureReason]:@""] cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^NSInteger(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex!=0) {
                    if (IS_IOS_8_LATER&(UIApplicationOpenSettingsURLString != NULL)) {
                        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                        if([[UIApplication sharedApplication] canOpenURL:url])
                        {
                            [[UIApplication sharedApplication] openURL:url];
                        }
                    }

                }
                return buttonIndex;
            }];
        }else{
            [[XYAPIService shareInstance] changeWorkingStatusInto:isWorking at:regeocode.formattedAddress success:^{
                [weakself hideLoadingMask];
                [weakself getWorkerStatus];
            } errorString:^(NSString *error) {
                [weakself hideLoadingMask];
                [weakself showToast:error];
            }];
        }
    }];
}

#pragma mark - update view

/**
 *  更新日期显示
 */
- (void)reloadDateDisplay{
   self.monthYearLabel.text =  [[NSDate date]formattedDateWithFormat:@"yyyy / MM / dd"];
}

//更新上班状态
- (void)updateStatusAndTimer{
    
    if (self.onlineTimer) {
        [self.onlineTimer invalidate];
        self.onlineTimer = nil;
    }
    
    if ([XYAPPSingleton sharedInstance].workerStatus.status == XYWorkerStatusOffWork) {
        [self.workButton setTitle:@"开始接单" forState:UIControlStateNormal];
        [self.workButton setBackgroundImage:[[UIImage imageNamed:@"btn_start_working"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal];
        self.statusLabel.text = @"当前状态：结束接单休息中";
    }else{
        [self.workButton setTitle:@"结束接单" forState:UIControlStateNormal];
        [self.workButton setBackgroundImage:[[UIImage imageNamed:@"btn_end_working"] stretchableImageWithLeftCapWidth:10 topCapHeight:10]  forState:UIControlStateNormal];
        
        if ([XYAPPSingleton sharedInstance].workerStatus.status == XYWorkerStatusHangUp) {
            self.statusLabel.text = @"当前状态：已挂起";
        }else{
            [self updateOnlineTime];
            self.onlineTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                target:self
                                                              selector:@selector(updateOnlineTime)
                                                              userInfo:nil
                                                              repeats:YES];
        }
    }
}

//更新计时数字
- (void)updateOnlineTime{
    NSString* statusStr = [NSString stringWithFormat:@"当前状态：%@  今日在线：%@",[XYAPPSingleton sharedInstance].workerStatus.statusStr?:@"",[XYAPPSingleton sharedInstance].workerStatus.onlineTimeStr?:@""];
    NSMutableAttributedString* attrStr = [[NSMutableAttributedString alloc]initWithString:statusStr];
    if ([XYAPPSingleton sharedInstance].workerStatus.statusStr) {
        NSRange rangeStatus = [statusStr rangeOfString:[XYAPPSingleton sharedInstance].workerStatus.statusStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:rangeStatus];
    }
    if ([XYAPPSingleton sharedInstance].workerStatus.onlineTimeStr) {
        NSRange rangeTimer = [statusStr rangeOfString:[XYAPPSingleton sharedInstance].workerStatus.onlineTimeStr];
        [attrStr addAttribute:NSForegroundColorAttributeName value:THEME_COLOR range:rangeTimer];
    }
    self.statusLabel.attributedText = attrStr;
}

- (void)onMyRankLoaded:(XYRankDto*)myRank{
    self.myRank = myRank;
}



#pragma mark - action

- (IBAction)goToNewsList:(id)sender {
    
    self.noticeButton.badgeValue = nil;
    //公告列表
    XYNoticeListViewController* noticeListController = [[XYNoticeListViewController alloc]init];
    [self.navigationController pushViewController:noticeListController animated:true];
}

- (IBAction)goToBonusList:(id)sender {
    //如果为加盟商工程师，禁止点击
    if ([XYAPPSingleton sharedInstance].currentUser.franchisee) {
        return;
    }
    XYBonusListViewController* bonusListController = [[XYBonusListViewController alloc]initWithType:XYBonusListTypeToday];
    [self.navigationController pushViewController:bonusListController animated:true];
}


- (IBAction)alterWorkingStatus:(id)sender{
    if ([XYAPPSingleton sharedInstance].workerStatus.status == XYWorkerStatusOffWork) {
        [XYAlertTool showConfirmCancelAlert:@"" message:@"是否确认\"开始接单\"？" onView:self action:^{
            [self changeWorkingStatusInto:true];
        } cancel:nil];
    }else{
        [XYAlertTool showConfirmCancelAlert:@"" message:@"每天只能点击一次\"结束接单\"，下班后就无法再次\"开始接单\"，是否确定\"结束接单\"？" onView:self action:^{
            [self changeWorkingStatusInto:false];
        } cancel:nil];
    }
}

- (void)logOut{
    [[XYAPPSingleton sharedInstance] removeAll];
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_LOGOUT object:nil];
    [[XYAPIService shareInstance]doLogout:nil errorString:nil];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showLoginView];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
