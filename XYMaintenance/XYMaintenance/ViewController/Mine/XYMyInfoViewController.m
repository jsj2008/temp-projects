//
//  XYMyInfoViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYMyInfoViewController.h"
#import "SimpleAlignCell.h"
#import "XYStarCell.h"
#import "XYRightAlignCell.h"
#import "XYMyInfoDetailViewController.h"
#import "XYAPIService+V3API.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XYMyInfoViewModel.h"
#import "XYPersonalEvaluationViewController.h"


@interface XYMyInfoViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)XYMyInfoViewModel* viewModel;
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)UIRefreshControl* refreshControl;
@end

@implementation XYMyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.hidden = true;
    [self loadMyInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYMyInfoViewModel alloc]init];
}

- (void)initializeUIElements{
    self.navigationItem.title = @"我的资料";
    [self.view addSubview:self.tableView];
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView =  [XYWidgetUtil getSimpleTableView:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = XY_COLOR(246, 248, 251);
        _tableView.separatorColor = XY_HEX(0xeeeeee);
        [_tableView addSubview:self.refreshControl];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
        [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
        [XYStarCell xy_registerTableView:_tableView identifier:[XYStarCell defaultReuseId]];
        [XYRightAlignCell xy_registerTableView:_tableView identifier:[XYRightAlignCell defaultReuseId]];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIRefreshControl*)refreshControl{
    if (!_refreshControl) {
        _refreshControl = [[UIRefreshControl alloc]init];
        [_refreshControl addTarget:self action:@selector(loadMyInfo) forControlEvents:UIControlEventValueChanged];
    }
    return _refreshControl;
}

#pragma mark - action

- (void)loadMyInfo{
    __weak __typeof(self)weakSelf = self;
   [[XYAPIService shareInstance] getMyInfoDetail:^(XYUserDetail *infoDetail) {
       [weakSelf.viewModel setInfoDetail:infoDetail];
       [weakSelf reloadInfoDetail];
       [weakSelf.refreshControl endRefreshing];
   } errorString:^(NSString *err) {
       [weakSelf.refreshControl endRefreshing];
       [weakSelf showToast:err];
   }];
}

- (void)reloadInfoDetail{
    [self.tableView reloadData];
    self.tableView.hidden = false;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYMyInfoCellType type = [self.viewModel getCellTypeByPath:indexPath];
    if (type == XYMyInfoCellTypeTowns || type == XYMyInfoCellTypeDistricts) {
        CGFloat height = [tableView fd_heightForCellWithIdentifier:[XYRightAlignCell defaultReuseId] configuration:^(id cell) {
            ((XYRightAlignCell*)cell).xyTitleLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
            ((XYRightAlignCell*)cell).xyContentLabel.text = [self.viewModel getContentByType:type];
        }] + 15;
        return (height > 50)? height:50;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return LINE_HEIGHT;
    }
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return [XYWidgetUtil getSingleLine];
    }
    return [XYWidgetUtil getSectionHeader:nil height:10 headerId:@"XYMyInfoViewHeaderId"];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYMyInfoCellType type = [self.viewModel getCellTypeByPath:indexPath];
    switch (type) {
        case XYMyInfoCellTypeSectionTitlePersonalInfo:
        case XYMyInfoCellTypeSectionTitleBusinessInfo:
        case XYMyInfoCellTypeSectionTitleOrdersInfo:
            return [self getSectionTitleCellForType:type];
            break;
        case XYMyInfoCellTypeStar:
            return [self getStarCell];
            break;
        default:
            return [self getRightAlignCellForType:type];
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //...todo
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    BOOL isSectionTitle = (indexPath.row == 0);
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, isSectionTitle?0:15, 0, isSectionTitle?0:15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, isSectionTitle?0:15, 0, isSectionTitle?0:15)];
    }
}


- (SimpleAlignCell*)getSectionTitleCellForType:(XYMyInfoCellType)type{
    SimpleAlignCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = [UIFont boldSystemFontOfSize:15.0];
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = true;
    cell.xyTextLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
    cell.xyDetailLabel.text = @"";
    return cell;
}

- (XYStarCell*)getStarCell{
    XYStarCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYStarCell defaultReuseId]];
    cell.rateView.rate = [self.viewModel.userDetail.eng_points floatValue];
    __weak __typeof(self)weakSelf = self;
    [cell setClickStarButtonBlock:^{
        XYPersonalEvaluationViewController *vc = [[XYPersonalEvaluationViewController alloc] init];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    return cell;
}

- (XYRightAlignCell*)getRightAlignCellForType:(XYMyInfoCellType)type{
    XYRightAlignCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYRightAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    cell.xyContentLabel.numberOfLines = 0;
    cell.xyTitleLabel.text = XY_NOTNULL([self.viewModel getTitleByType:type],@"");
    cell.xyContentLabel.text = XY_NOTNULL([self.viewModel getContentByType:type],@"");
    switch (type) {
        case XYMyInfoCellTypeUseLimit:
            cell.xyContentLabel.textColor = THEME_COLOR;
            break;
        case XYMyInfoCellTypeMonthComplete:
            cell.xyContentLabel.textColor = REVERSE_COLOR;
            break;
        case XYMyInfoCellTypeOvertimeCount:
            cell.xyContentLabel.textColor = XY_HEX(0xff4b4b);
            break;
        default:
            cell.xyContentLabel.textColor = BLACK_COLOR;
            break;
    }
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
