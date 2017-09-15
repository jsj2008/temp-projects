//
//  XYCompleteOrderViewController.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderViewController.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "XYCompleteOrderCommonHeaderCell.h"
#import "XYCompleteOrderSpecialHeaderCell.h"
#import "XYCompleteOrderCell.h"
#import "XYCompleteOrderPlatformFeeCell.h"
#import "XYCompleteOrderPlatformFeeBarView.h"
#import "XYAPIService+V6API.h"
#import "XYAPIService+V11API.h"
#import "MJRefresh.h"
#import <Masonry.h>
#import "XYPayUtil.h"
#import "SDTrackTool.h"

@interface XYCompleteOrderViewController ()<SKSTableViewDelegate>

@property (strong, nonatomic) XYCompleteOrderPlatformFeeBarView *barView;
@property (strong, nonatomic) NSMutableArray *userOrderList;
@property (strong, nonatomic) NSArray *unpaidfeeList;
@property (strong, nonatomic) NSArray *paidfeeList;
@property (assign, nonatomic) BOOL isSelectAll;
@property(strong,nonatomic) XYPayUtil* payUtil;

@end

@implementation XYCompleteOrderViewController

#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTabelView];
    [self initPlatformFeeBarView];
    [self loadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_EDIT_REPAIR_OLD_ORDER object:nil];
}

#pragma mark - InitUI
- (void)initTabelView {
    self.tableView.backgroundColor = XY_HEX(0xEEF0F3);
    self.tableView.SKSTableViewDelegate = self;
    self.tableView.shouldExpandOnlyOneCell = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
    [self.tableView addXYHeaderWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [XYCompleteOrderCommonHeaderCell xy_registerTableView:_tableView identifier:[XYCompleteOrderCommonHeaderCell defaultReuseId]];
    [XYCompleteOrderSpecialHeaderCell xy_registerTableView:_tableView identifier:[XYCompleteOrderSpecialHeaderCell defaultReuseId]];
    [XYCompleteOrderCell xy_registerTableView:_tableView identifier:[XYCompleteOrderCell defaultIdentifier]];
    [XYCompleteOrderPlatformFeeCell xy_registerTableView:_tableView identifier:[XYCompleteOrderPlatformFeeCell defaultIdentifier]];
}

- (void)initPlatformFeeBarView {
    XYCompleteOrderPlatformFeeBarView *barView = [[XYCompleteOrderPlatformFeeBarView alloc] init];
    [self.view addSubview:barView];
    [self.view bringSubviewToFront:barView];
    [barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left).offset(0);
        make.right.equalTo(self.view.mas_right).offset(0);
        make.height.mas_equalTo(60);
    }];
    __weak __typeof(self)weakSelf = self;
    [barView setSubmitFeeBlock:^{
        [weakSelf submitFeeRequest];
    }];
    self.barView = barView;
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    switch (indexPath.row) {
        case 0:
            cell = [self getCommonHeaderCell:indexPath];
            break;
        case 1:
            cell = [self getSpecialHeaderCell:indexPath];
            break;
        case 2:
            cell = [self getCommonHeaderCell:indexPath];
            break;
            
        default:
            break;
    }
    return cell;
}

- (XYCompleteOrderCommonHeaderCell *)getCommonHeaderCell:(NSIndexPath*)indexPath{
    XYCompleteOrderCommonHeaderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYCompleteOrderCommonHeaderCell defaultReuseId]];
    cell.expandable = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row==0) {
        cell.titleLabel.text = @"用户待支付";
        cell.isFirst = YES;
    }else if (indexPath.row==2) {
        cell.titleLabel.text = @"平台费已支付";
        cell.isFirst = NO;
    }
    return cell;
}

- (XYCompleteOrderSpecialHeaderCell *)getSpecialHeaderCell:(NSIndexPath*)indexPath{
    XYCompleteOrderSpecialHeaderCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYCompleteOrderSpecialHeaderCell defaultReuseId]];
    cell.expandable = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    for (XYAllTypeOrderDto *feeDto in self.unpaidfeeList) {
        if (!feeDto.platform_fee_selected) {
            self.isSelectAll = NO;
            break;
        }else {
            self.isSelectAll = YES;
        }
    }
    cell.isSelectAll = self.isSelectAll;
    cell.feeCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.unpaidfeeList.count];
    CGFloat totalPrice = 0;
    for (XYAllTypeOrderDto *feeDto in self.unpaidfeeList) {
        totalPrice += [feeDto.platform_fee floatValue];
    }
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", totalPrice];
    
    __weak __typeof(self)weakSelf = self;
    [cell setSelectAllBlock:^{
        BOOL seleced = weakSelf.isSelectAll;
        weakSelf.isSelectAll = !seleced;
        if (weakSelf.isSelectAll) {
            for (XYAllTypeOrderDto *feeDto in weakSelf.unpaidfeeList) {
                feeDto.platform_fee_selected = YES;
            }
        }else {
            for (XYAllTypeOrderDto *feeDto in weakSelf.unpaidfeeList) {
                feeDto.platform_fee_selected = NO;
            }
        }
        [weakSelf reloadData];
    }];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 40.0f;
    }else {
        return 50.0f;
    }
    return 0.0f;
}

-(void)tableView:(SKSTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - SKSTableViewDelegate
- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return self.userOrderList.count;
        case 1:
            return self.unpaidfeeList.count;
        case 2:
            return self.paidfeeList.count;
            break;
            
        default:
            break;
    }
    return 2;
}

- (UITableViewCell *)tableView:(SKSTableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *subCell;
    switch (indexPath.row) {
        case 0:
        {
            XYCompleteOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYCompleteOrderCell defaultIdentifier]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            XYAllTypeOrderDto *item = [self.userOrderList objectAtIndex:indexPath.subRow-1];
            [cell setAllTypeOrderData:item];
            subCell =cell;
        }
            break;
        case 1:
        {
            XYCompleteOrderPlatformFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYCompleteOrderPlatformFeeCell defaultIdentifier]];
            cell.rowNo = indexPath.subRow-1;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.platformFeeDto = self.unpaidfeeList[indexPath.subRow-1];
            __weak __typeof(self)weakSelf = self;
            [cell setSelectBlock:^(NSInteger rowNo){
                if (!weakSelf.unpaidfeeList.count) {
                    return;
                }
                XYAllTypeOrderDto *feeDto = weakSelf.unpaidfeeList[rowNo];
                BOOL selected = feeDto.platform_fee_selected;
                feeDto.platform_fee_selected = !selected;
                [weakSelf reloadData];
            }];
            subCell =cell;
        }
            break;
        case 2:
        {
            XYCompleteOrderPlatformFeeCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYCompleteOrderPlatformFeeCell defaultIdentifier]];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle =UITableViewCellSelectionStyleNone;
            cell.platformFeeDto = self.paidfeeList[indexPath.subRow-1];
            subCell =cell;
        }
            break;
            
        default:
            break;
    }
    
    return subCell;
}

-(CGFloat)tableView:(SKSTableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.row==0) {
        height = [XYCompleteOrderCell getHeight];
    }else {
        height = [XYCompleteOrderPlatformFeeCell getHeight];
    }

    return height;
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath {
    [SDTrackTool logEvent:@"PAGE_EVENT_XYOrderDetailViewController_COMPLETE"];
    switch (indexPath.row) {
        case 0:
        {
            XYAllTypeOrderDto *item = [self.userOrderList objectAtIndex:indexPath.subRow-1];
            [self.orderTableViewDelegate goToAllOrderDetail:item.id type:item.type bid:item.bid];
        }
            break;
        case 1:
        {
            XYAllTypeOrderDto *item = [self.unpaidfeeList objectAtIndex:indexPath.subRow-1];
            [self.orderTableViewDelegate goToAllOrderDetail:item.id type:item.type bid:item.bid];
        }
            break;
        case 2:
        {
            XYAllTypeOrderDto *item = [self.paidfeeList objectAtIndex:indexPath.subRow-1];
            [self.orderTableViewDelegate goToAllOrderDetail:item.id type:item.type bid:item.bid];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Private methods
- (void)registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserLogout) name:XY_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewUserLogin) name:XY_NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshOldOrder) name:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editOldOrder:) name:XY_NOTIFICATION_EDIT_REPAIR_OLD_ORDER object:nil];
}

- (void)loadData {
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance] getCompleteOrderList:1 success:^(NSMutableArray<XYAllTypeOrderDto *> *userOrderList, NSArray<XYAllTypeOrderDto *> *unpaidfeeList, NSArray<XYAllTypeOrderDto *> *paidfeeList,NSInteger sum) {
        [weakSelf.tableView.header endRefreshing];
        weakSelf.userOrderList = userOrderList;
        weakSelf.unpaidfeeList = unpaidfeeList;
        weakSelf.paidfeeList = paidfeeList;
        [weakSelf reloadData];
        !_resetTitleCountBlock ?: _resetTitleCountBlock(sum);
    } errorString:^(NSString *err) {
        [weakSelf.tableView.header endRefreshing];
        [weakSelf showToast:err];
    }];
}

- (void)submitFeeRequest {
    NSString *totalStr=@"";
    int totalCount = 0;
    for (XYAllTypeOrderDto *feeDto in self.unpaidfeeList) {
        if (feeDto.platform_fee_selected) {
            totalStr = [totalStr stringByAppendingString:feeDto.id];
            totalStr = [totalStr stringByAppendingString:@","];
            totalCount += 1;
        }
    }
    if (![XYStringUtil isNullOrEmpty:totalStr]) {
        totalStr = [totalStr substringToIndex:[totalStr length]-1];
    }else {
        [self showToast:@"请选择平台费!"];
        return;
    }
    
    if (totalCount>10) {
        [self showToast:@"最多同时结算10笔！"];
        return;
    }
   
    [self showLoadingMask];
    __weak __typeof(self)weakSelf = self;
    [self.payUtil alipayPlatformfeeWithId_str:totalStr success:^{
        [weakSelf loadData];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:@"平台费支付成功"];
    } failure:^(NSString *error) {
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (void)reloadData {
    [self.tableView refreshData];
    [self.barView setDataArr:self.unpaidfeeList];
}

- (void)collapseSubrows {
    [self.tableView collapseCurrentlyExpandedIndexPaths];
}

- (XYPayUtil*)payUtil{
    if (!_payUtil) {
        _payUtil = [[XYPayUtil alloc]init];
    }
    return _payUtil;
}


- (NSMutableArray*)userOrderList{
    if (!_userOrderList) {
        _userOrderList = [[NSMutableArray alloc]init];
    }
    return _userOrderList;
}

- (NSArray*)paidfeeList{
    if (!_paidfeeList) {
        _paidfeeList = [[NSArray alloc]init];
    }
    return _paidfeeList;
}

- (NSArray*)unpaidfeeList{
    if (!_unpaidfeeList) {
        _unpaidfeeList = [[NSArray alloc]init];
    }
    return _unpaidfeeList;
}

#pragma mark - notification
- (void)onNewUserLogin{
    [self loadData];
}

- (void)onUserLogout {
    self.userOrderList = nil;
    self.paidfeeList = nil;
    self.unpaidfeeList = nil;
    [self reloadData];
}

- (void)refreshOldOrder {
    [self loadData];
}

- (void)editOldOrder:(NSNotification*)notification{
    //    XYOrderBase* orderBase = notification.object;
    //    [self updateRepairOrder:orderBase];
    [self loadData];
}

//- (void)updateRepairOrder:(XYOrderBase *)orderBase{
//    
//    for (XYAllTypeOrderDto* order in self.userOrderList) {
//        //只有维修订单！
//        if ((order.type == XYAllOrderTypeRepair) && [order.id isEqualToString:orderBase.id]) {
//            XYAllTypeOrderDto* newOrder = [XYAllTypeOrderDto convertRepairOrder:orderBase from:order];
//            [self replaceObjectWith:newOrder atIndex:[self.userOrderList indexOfObject:order]];
//            break;
//        }
//    }
//    [self reloadData];
//}
//
//- (void)replaceObjectWith:(id)obj atIndex:(NSInteger)index{
//    
//    if ((!obj) || index >= self.userOrderList.count || index < 0) {
//        return;
//    }
//    
//    [self.userOrderList replaceObjectAtIndex:index withObject:obj];
//}


@end
