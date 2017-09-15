//
//  XYOrderDaysTableView.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOrderDaysTableView.h"
#import "XYWidgetUtil.h"
#import "MJRefresh.h"
#import "XYConfig.h"
#import "API.h"
#import "NSDate+DateTools.h"
#import "XYRefreshLegendHeader.h"
#import "XYClearedOrderCell.h"
#import "UITableViewCell+XYTableViewRegister.h"

static NSString *const XYOrderDaysSimpleCellIdentifier = @"XYOrderDaysSimpleCellIdentifier";

@implementation XYOrderDaysTableView

#pragma mark - property 

- (NSArray*)todayOrderList{
    if (!_todayOrderList) {
        _todayOrderList = [[NSArray alloc]init];
    }
    return _todayOrderList;
}

- (NSArray*)daysList{
    if (!_daysList) {
        _daysList = [[NSArray alloc]init];
    }
    return _daysList;
}

#pragma mark - init

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
    [self addXYHeaderWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    [XYClearedOrderCell xy_registerTableView:self identifier:[XYClearedOrderCell defaultIdentifier]];
}

#pragma mark - action

- (void)refresh{
    
    //当前日期
    NSString* todayStr = [[NSDate date] formattedDateWithFormat:@"yyyyMMdd"];
    
    dispatch_group_t group = dispatch_group_create();
    
    //刷新今天的订单
    dispatch_group_enter(group);
    [[XYAPIService shareInstance]getAllClearOrderList:todayStr page:1 success:^(NSArray<XYAllTypeOrderDto *> *orderList, NSInteger sum) {
        self.todayOrderList = orderList? orderList:[[NSArray alloc]init];
        dispatch_group_leave(group);
    } errorString:^(NSString *error) {
        dispatch_group_leave(group);
    }];
    
    if (self.daysList.count == 0 ) {
        //如果日期列表不存在，再刷一次
        //否则保持原样即可 不要费流量。。。
        dispatch_group_enter(group);
        [[XYAPIService shareInstance]getAllDaysWithClearOrders:^(NSArray<NSString *> *daysList) {
            self.daysList = daysList? daysList:[[NSArray alloc]init];
            dispatch_group_leave(group);
        } errorString:^(NSString *err) {
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.xyHeader endRefreshing];
        [self reloadData];
        [self.orderTableViewDelegate reloadOrderCount:[self.todayOrderList count] forIndex:XYOrderListSegmentTypeCleared];
    });

}

- (void)reset{
    self.todayOrderList = nil;
    self.daysList = nil;
    [self reloadData];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [self.todayOrderList count] ;
    }else if(section == 1){
        return [self.daysList count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [XYClearedOrderCell getHeight];
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
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section==0) {
        XYAllTypeOrderDto* order = [self.todayOrderList objectAtIndex:indexPath.row];
        [self.orderTableViewDelegate goToAllOrderDetail:order.id type:order.type bid:order.bid];
    }else{
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath] ;
        [self.orderTableViewDelegate goToClearFoldDay:cell.textLabel.text];
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

- (XYClearedOrderCell*)getClearedOrderCell:(NSIndexPath*)indexPath{
    XYClearedOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYClearedOrderCell defaultIdentifier]];
    XYAllTypeOrderDto* order = [self.todayOrderList objectAtIndex:indexPath.row];
    [cell setAllTypeOrder:order];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
