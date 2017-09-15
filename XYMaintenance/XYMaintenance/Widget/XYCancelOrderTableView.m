//
//  XYCancelOrderTableView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/4/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCancelOrderTableView.h"
#import "XYWidgetUtil.h"
#import "MJRefresh.h"
#import "XYConfig.h"
#import "XYAPIService+V3API.h"
#import "XYRefreshLegendHeader.h"
#import "XYCancelOrderCell.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "XYOrderListManager.h"
#import "SDTrackTool.h"

static NSString *const XYOrderDaysSimpleCellIdentifier = @"XYOrderDaysSimpleCellIdentifier";


@implementation XYCancelOrderTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        [self setUpAppearance];
    }
    return self;
}

- (void)setUpAppearance{
    self.backgroundColor = BACKGROUND_COLOR;
    self.separatorColor = TABLE_DEVIDER_COLOR;
    [self setTableHeaderView:[XYWidgetUtil getSingleLine]];
    [self setTableFooterView:[XYWidgetUtil getSingleLine]];
    [self addXYHeaderWithRefreshingTarget:self refreshingAction:@selector(updateCancelledOrders)];
//    [self.footer setTitle:@"点击查看更多日期" forState:MJRefreshFooterStateIdle];
//    [self.footer setTitle:@"正在获取更多日期" forState:MJRefreshFooterStateRefreshing];
//    self.footer.hidden = true;
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    [XYCancelOrderCell xy_registerTableView:self identifier:[XYCancelOrderCell defaultReuseId]];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section==0){
        return [self.ordersList count] ;
    }else if(section ==1){
        return [self.daysList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [XYCancelOrderCell getHeight];
    }
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getClearedOrderCell:indexPath];
    }
    return [self getSimpleTableViewCell:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SDTrackTool logEvent:@"PAGE_EVENT_XYOrderDetailViewController_CANCEL"];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==0) {
        XYCancelOrderDto* orderBase = [self.ordersList objectAtIndex:indexPath.row];
        [self.orderTableViewDelegate goToCancelOrder:orderBase.order_id bid:orderBase.bid];
    }else{
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self.orderTableViewDelegate goToCancelDay:cell.textLabel.text];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        if (indexPath.section == 0) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }else{
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        if (indexPath.section == 0) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }else{
            [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
        }
    }
}

#pragma mark - cell

- (XYCancelOrderCell*)getClearedOrderCell:(NSIndexPath*)indexPath{
    XYCancelOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYCancelOrderCell defaultReuseId]];
    [cell setData:[self.ordersList objectAtIndex:indexPath.row] type:true];
    return cell;
}

- (UITableViewCell*)getSimpleTableViewCell:(NSIndexPath*)path{
    UITableViewCell* cell = [self dequeueReusableCellWithIdentifier:XYOrderDaysSimpleCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYOrderDaysSimpleCellIdentifier];
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.textColor = LIGHT_TEXT_COLOR;
        cell.accessoryView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_right"]];
    }
    cell.textLabel.text = [self.daysList objectAtIndex:path.row];
    return cell;
}


#pragma mark - action 

- (void)updateCancelledOrders{
   
    [[XYAPIService shareInstance]getCancelOrderList:^(NSArray<XYCancelOrderDto *> *pendingOrders, NSArray<NSString *> *oldDays) {
        [self.header endRefreshing];
        self.ordersList = pendingOrders?pendingOrders:[[NSArray alloc]init];
        self.daysList = oldDays?oldDays:[[NSArray alloc]init];
        [self reloadData];
        [self.orderTableViewDelegate reloadOrderCount:self.ordersList.count forIndex:XYOrderListSegmentTypeCancel];
    } errorString:^(NSString *error) {
        [self.header endRefreshing];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
