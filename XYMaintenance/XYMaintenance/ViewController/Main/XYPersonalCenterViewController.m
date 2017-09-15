//
//  XYPersonalCenterViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYPersonalCenterViewController.h"
#import "XYPersonalCenterViewModel.h"
#import "XYUserHeaderView.h"
#import "XYContactsViewController.h"
#import "XYMyPartsViewController.h"
#import "XYNoticeViewController.h"
#import "XYWidgetUtil.h"
#import "XYSettingCell.h"
#import "XYNoticeCell.h"
#import "AppDelegate.h"
#import "XYBonusBaseCell.h"
#import "XYPromotionMainViewController.h"
#import "XYSettingViewController.h"
#import "XYBonusListViewController.h"
#import "XYMyInfoViewController.h"

static NSString *const XYPersonalCenterHeaderCellIdentifier = @"XYPersonalCenterHeaderCell";

@interface XYPersonalCenterViewController ()<UITableViewDelegate,UITableViewDataSource,XYPersonalCenterCallBackDelegate>
//UI
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)XYUserHeaderView* headerView;
//DATA
@property(strong,nonatomic)XYPersonalCenterViewModel* viewModel;
@property(strong,nonatomic)NSArray* titlesArray;
@property(strong,nonatomic)NSArray* imgArray;

@property(assign,nonatomic)BOOL shouldShowPartRedSpot;

@end

@implementation XYPersonalCenterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel loadBonusData];
}
#pragma mark - override

- (void)registerForNotifications{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(onNewUserLogin) name:XY_NOTIFICATION_LOGIN object:nil];
}

- (void)initializeModelBinding{
    self.viewModel = [[XYPersonalCenterViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"个人中心";
    [self shouldShowBackButton:false];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_setting"] style:UIBarButtonItemStylePlain target:self action:@selector(goToSetting)];
    [self.view addSubview:self.tableView];
}

#pragma mark - property 

- (NSArray*)titlesArray{
    if(!_titlesArray){
        XYUserType type = [XYAPPSingleton sharedInstance].currentUser.is_promotion;
        switch (type) {
            case XYUserTypeEngineer:
                _titlesArray = @[@[@"",@""],@[@"消息通知",@"企业通讯录",@"我的配件"]];//纯工程师 有提成无地推
                break;
            case XYUserTypePromoter:
                _titlesArray = @[@[@""],@[@"消息通知",@"企业通讯录",@"我的配件",@"地推中心"]];//纯推广，无提成有地推
                break;
            default:
                _titlesArray = @[@[@"",@""],@[@"消息通知",@"企业通讯录",@"我的配件",@"地推中心"]];//默认都有
                break;
        }
    }
    return _titlesArray;
}

- (NSArray*)imgArray{
    if (!_imgArray) {
        XYUserType type = [XYAPPSingleton sharedInstance].currentUser.is_promotion;
        switch (type) {
            case XYUserTypeEngineer:
                _imgArray = @[@[@"",@""],@[@"user_notice",@"user_contact",@"user_part"]];//纯工程师 有提成无地推
                break;
            case XYUserTypePromoter:
                _imgArray = @[@[@""],@[@"user_notice",@"user_contact",@"user_part",@"user_tfc"]];//纯推广，无提成有地推
                break;
            default:
                _imgArray = @[@[@"",@""],@[@"user_notice",@"user_contact",@"user_part",@"user_tfc"]];//默认都有
                break;
        }
    }
    return _imgArray;
}

- (XYUserHeaderView*)headerView{
    if (!_headerView) {
        _headerView = [[XYUserHeaderView alloc]init];
        [_headerView.infoButton addTarget:self action:@selector(goToMyInfo) forControlEvents:UIControlEventTouchUpInside];
    }
    [_headerView setUserInfo:[XYAPPSingleton sharedInstance].currentUser];
    return _headerView;  
}

- (UITableView*)tableView{
    if (!_tableView) {
        CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
        _tableView = [XYWidgetUtil getSimpleTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - tabbarHeight - NAVI_BAR_HEIGHT)];
        _tableView.separatorColor = XY_HEX(0xeef0f3);
        _tableView.backgroundColor = XY_COLOR(238,240,243);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:TABLE_DEVIDER_COLOR]];
        [XYSettingCell xy_registerTableView:_tableView identifier:[XYSettingCell defaultReuseIdentifier]];
        [XYBonusBaseCell xy_registerTableView:_tableView identifier:[XYBonusBaseCell defaultIdentifier]];
    }
    return _tableView;
}

#pragma mark - phone call

- (void)callServicePhone{
#warning XYAlertTool
    if (IS_IOS_10_LATER) {
        [XYAlertTool callPhone:SERVICE_PHONE onView:self];
    }else {
        [XYAlertTool showPhoneAlert:SERVICE_PHONE onView:self];
    }
}

#pragma mark - 跳转逻辑

- (void)goToPromotion{
    XYPromotionMainViewController* promotionViewController = [[XYPromotionMainViewController alloc]init];
    [self.navigationController pushViewController:promotionViewController animated:true];
}

- (void)goToNoticeList{
    XYNoticeViewController* noticeViewController = [[XYNoticeViewController alloc]init];
    [self.navigationController pushViewController:noticeViewController animated:true];
}

- (void)goToContacts{
    XYContactsViewController* contactsViewController = [[XYContactsViewController alloc]init];
    [self.navigationController pushViewController:contactsViewController animated:true];
}

- (void)goToMyParts:(BOOL)isClaimPartsNotify{
    //去掉红点
    self.shouldShowPartRedSpot = false;
    
    //检查堆栈
    BOOL hasNewsListInStack = false;
    for(UIViewController* vc in self.navigationController.viewControllers){
        if ([vc isKindOfClass:[XYMyPartsViewController class]]) {
            [self.navigationController popToViewController:vc animated:false];
            [((XYMyPartsViewController*)vc) refreshRecordList];
            hasNewsListInStack = true;
            break;
        }
    }
    
    if (!hasNewsListInStack) {
        XYMyPartsViewController* partsViewController = [[XYMyPartsViewController alloc]init];
        partsViewController.isClaimPartsNotify = isClaimPartsNotify;
        [self.navigationController pushViewController:partsViewController animated:true];
    }
    
}

//- (void)goToTraceRecord{
//    XYTrafficCalenderViewController* trafficViewController = [[XYTrafficCalenderViewController alloc]init];
//    [self.navigationController pushViewController:trafficViewController animated:true];
//}

- (void)goToBonusList:(UIButton*)btn{
    //如果为加盟商工程师，禁止点击
    if ([XYAPPSingleton sharedInstance].currentUser.franchisee) {
        return;
    }
    XYBonusListType type = btn.tag;
    XYBonusListViewController* bonusViewController = [[XYBonusListViewController alloc]initWithType:type];
    [self.navigationController pushViewController:bonusViewController animated:true];
}

- (void)goToSetting{
    XYSettingViewController* settingViewController = [[XYSettingViewController alloc]init];
    settingViewController.viewModel = self.viewModel;
    [self.navigationController pushViewController:settingViewController animated:true];
}

- (void)onNewUserLogin{
    //清空排版
    self.titlesArray = nil;
    self.imgArray = nil;
    [self.headerView setUserInfo:[XYAPPSingleton sharedInstance].currentUser];
    [self.tableView reloadData];
    //[self.navigationController popToRootViewControllerAnimated:false];
}

- (void)goToMyInfo{
    XYMyInfoViewController* infoViewController = [[XYMyInfoViewController alloc]init];
    [self.navigationController pushViewController:infoViewController animated:true];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titlesArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = [self.titlesArray objectAtIndex:section];
    return arr.count;
//    return [[self.titlesArray objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self getHeaderCell];
        }else if(indexPath.row == 1){
            return [self getBonusCell];
        }
    }else{
        return [self getCellByIndexPath:indexPath];
    }
    return nil;
}

- (UITableViewCell*)getHeaderCell{
   UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:XYPersonalCenterHeaderCellIdentifier];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYPersonalCenterHeaderCellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell addSubview:self.headerView];
    }
    return cell;
}

- (XYBonusBaseCell*)getBonusCell{
    XYBonusBaseCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYBonusBaseCell defaultIdentifier]];
    [cell setBonusAmountData:self.viewModel.bonusData];
    [cell.todayBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.monthBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.totalBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (XYSettingCell*)getCellByIndexPath:(NSIndexPath*)indexPath{
    XYSettingCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYSettingCell defaultReuseIdentifier]];
    cell.titleTextLabel.font = SIMPLE_TEXT_FONT;
    cell.titleTextLabel.textColor = BLACK_COLOR;
    cell.titleTextLabel.text = [[self.titlesArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    cell.thumbnailView.image = [UIImage imageNamed:[[self.imgArray objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    if ([cell.titleTextLabel.text isEqualToString:@"我的配件"]) {
        [cell setBadgeNumber:self.shouldShowPartRedSpot?1:0 hideNumber:true];
    }else{
        [cell setBadgeNumber:0 hideNumber:true];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            return self.headerView.frame.size.height;;
        }else if(indexPath.row == 1){
            return [XYBonusBaseCell getHeight];
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return 0;
    }
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [[UIView alloc]init];
    }
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = XY_COLOR(238,240,243);
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 1){
        switch (indexPath.row){
            case 0:
                //[self goToNoticeList];
                break;
            case 1:
               // [self goToTraceRecord];
                break;
            case 2:
            {
                //如果为加盟商工程师，禁止点击
                if ([XYAPPSingleton sharedInstance].currentUser.franchisee) {
                    return;
                }
                if([XYAPPSingleton sharedInstance].currentUser.is_promotion != XYUserTypePromoter){
                    //不是纯地推，有工程师属性即可进入
                    [self goToMyParts:NO];
                }
            }
                break;
            case 3:
                [self goToPromotion];
                break;
            default:
                break;
        }
    }
}
    




- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - call back

- (void)onBonusLoaded:(BOOL)success note:(NSString *)noteStr{
    if (success) {
        [self.tableView reloadData];
    }
}

#pragma mark - red spot

- (void)showRedSpotOnParts{
   //配件红点
    self.shouldShowPartRedSpot = true;
    [self.tableView reloadData];
}


//#pragma mark - view Style
//
//- (void)setNoticesCount:(NSInteger)count{
//    if (count > 0){
//        _noticeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
//        CGSize size = [_noticeCountLabel.text sizeWithAttributes:@{NSFontAttributeName:_noticeCountLabel.font}];
//        _noticeCountLabel.frame = CGRectMake(0, 0, size.width + 10, size.height);
//        _noticeCountLabel.center = CGPointMake(ScreenWidth - 30 - (size.width + 10)/2, 25);
//        _noticeCountLabel.layer.cornerRadius = size.height/2;
//        _noticeCountLabel.layer.masksToBounds = true;
//        _noticeCountLabel.hidden = false;
//    }else{
//        _noticeCountLabel.hidden = true;
//    }
//}



//#pragma mark - call back
//
//- (void)onVersionUpdateChecked:(BOOL)shouldUpdate{
//    [self hideLoadingMask];
//    if (shouldUpdate){
//        if (![[UIApplication sharedApplication]openURL:[NSURL URLWithString:_viewModel.downloadUrl]]) {
//            XYWebViewController* webViewController = [[XYWebViewController alloc]initWithNSUrl:[NSURL URLWithString:_viewModel.downloadUrl]];
//            webViewController.hidesBottomBarWhenPushed = true;
//            [self.navigationController pushViewController:webViewController animated:true];
//        }
//    }else{
//        [self showToast:@"已是最新版本"];
//    }
//}

//
//- (UILabel*)noticeCountLabel{
//    if (!_noticeCountLabel) {
//        _noticeCountLabel = [[UILabel alloc]init];
//        _noticeCountLabel.backgroundColor = XY_COLOR(255,42,42);
//        _noticeCountLabel.font = SIMPLE_TEXT_FONT;
//        _noticeCountLabel.textColor = WHITE_COLOR;
//        _noticeCountLabel.textAlignment = NSTextAlignmentCenter;
//    }
//    return _noticeCountLabel;
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
