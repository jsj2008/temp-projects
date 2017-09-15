//
//  XYPromotionMainViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPromotionMainViewController.h"
#import "XYBonusBaseCell.h"
#import "XYSettingViewController.h"
#import "XYPromotionBonusViewController.h"
#import "XYAPIService+V5API.h"
#import "XYQRcodeUtil.h"
#import "UIImageView+YYWebImage.h"
#import "SDTrackTool.h"

@interface XYPromotionMainViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic) UIRefreshControl* refreshControl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeView;

@property (strong,nonatomic) XYPromotionBonusDto* bonusData;
@end

@implementation XYPromotionMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self updateBonusData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override

- (void)initializeUIElements{
    
    self.navigationItem.title = @"地推中心";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    [self.tableView addSubview:self.refreshControl];
    [self.tableView setTableFooterView:self.footerView];
    [XYBonusBaseCell xy_registerTableView:self.tableView identifier:[XYBonusBaseCell defaultIdentifier]];
    self.footerView.backgroundColor = BACKGROUND_COLOR;
    self.deviderHeight.constant = LINE_HEIGHT;

    [self.qrcodeView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.hiweixiu.com/qrcode/arearecommend?state=%@",[XYAPPSingleton sharedInstance].currentUser.Id]] placeholder:nil options:YYWebImageOptionHandleCookies completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        if (!image) {
            NSString* qrcodeUrl = [NSString stringWithFormat:@"https://m.hiweixiu.com/arearecommend/grant?state=%@",[XYAPPSingleton sharedInstance].currentUser.Id];
            self.qrcodeView.image = [XYQRcodeUtil creatQRcodeWithUrlstring:qrcodeUrl size:CGSizeMake(150, 150)];
        }
    }];
}

#pragma mark - property

- (UIRefreshControl*)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(updateBonusData) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - action

- (void)updateBonusData{

    
    __weak typeof(self) weakSelf = self;
    
    [[XYAPIService shareInstance] getPromotionBonusData:^(XYPromotionBonusDto *bonus) {
        [weakSelf.refreshControl endRefreshing];
        weakSelf.bonusData = bonus;
        [weakSelf.tableView reloadData];
    } errorString:^(NSString *error) {
        [weakSelf.refreshControl endRefreshing];
        [weakSelf showToast:error];
    }];
}


- (void)goToBonusList:(UIButton*)btn{
    
    XYBonusListType type = btn.tag;
    XYPromotionBonusViewController* bonusViewController = [[XYPromotionBonusViewController alloc]initWithType:type];
    [self.navigationController pushViewController:bonusViewController animated:true];
    switch (type) {
        case XYBonusListTypeMonth:
            [SDTrackTool logEvent:@"CTRL_EVENT_XYPromotionMainViewController_MONTH"];
            break;
        case XYBonusListTypeToday:
            [SDTrackTool logEvent:@"CTRL_EVENT_XYPromotionMainViewController_TODAY"];
            break;
        case XYBonusListTypeTotal:
            [SDTrackTool logEvent:@"CTRL_EVENT_XYPromotionMainViewController_TOTAL"];
            break;

        default:
            break;
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getBonusCell];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    return [XYBonusBaseCell getHeight];
}

#pragma mark - cell

- (XYBonusBaseCell*)getBonusCell{
    XYBonusBaseCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYBonusBaseCell defaultIdentifier]];
    [cell setBonusCountData:self.bonusData];
    [cell.todayBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.monthBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    [cell.totalBonusButton addTarget:self action:@selector(goToBonusList:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
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
