//
//  XYAllOrdersTableView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/15.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAllOrdersTableView.h"
#import "XYConfig.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "NSDate+DateTools.h"
#import "SDTrackTool.h"

@interface XYAllOrdersTableView (){
    UIView* _orderListEmptyView;
}
@end

@implementation XYAllOrdersTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        self.type = XYAllOrderListViewTypeUnknown;
    }
    return self;
}

- (void)setType:(XYAllOrderListViewType)type{
    _type = type;
    switch (type) {
        case XYAllOrderListViewTypeIncomplete:
            [XYIncompleteOrderCell xy_registerTableView:self identifier:[XYIncompleteOrderCell defaultIdentifier]];
            break;
        case XYAllOrderListViewTypeCompleted:
            [XYCompleteOrderCell xy_registerTableView:self identifier:[XYCompleteOrderCell defaultIdentifier]];
            break;
        case XYAllOrderListViewTypeCleared:
            [XYClearedOrderCell xy_registerTableView:self identifier:[XYClearedOrderCell defaultIdentifier]];
            break;
        default:
            break;
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.type) {
        case XYAllOrderListViewTypeIncomplete:
        case XYAllOrderListViewTypeCompleted:
        case XYAllOrderListViewTypeCleared:
            return 1;
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataList count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYAllOrderListViewTypeIncomplete:
            return [self getInCompleteOrderCell:indexPath];
            break;
        case XYAllOrderListViewTypeCompleted:
            return [self getCompletedOrderCell:indexPath];
            break;
        case XYAllOrderListViewTypeCleared:
            return [self getClearedOrderCell:indexPath];
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYAllOrderListViewTypeIncomplete:
            return [XYIncompleteOrderCell getHeight];
            break;
        case XYAllOrderListViewTypeCompleted:
            return [XYCompleteOrderCell getHeight];
            break;
        case XYAllOrderListViewTypeCleared:
            return [XYClearedOrderCell getHeight];
            break;
        default:
            break;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [SDTrackTool logEvent:@"PAGE_EVENT_XYOrderDetailViewController_INCOMPLETE"];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYAllTypeOrderDto *item = [self.dataList objectAtIndex:indexPath.row];
    [self.orderTableViewDelegate goToAllOrderDetail:item.id type:item.type bid:item.bid];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (XYIncompleteOrderCell*)getInCompleteOrderCell:(NSIndexPath*)indexPath{
    XYIncompleteOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYIncompleteOrderCell defaultIdentifier]];
    [cell.phoneCallButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    cell.phoneCallButton.tag = indexPath.row;
    XYAllTypeOrderDto *item = [self.dataList objectAtIndex:indexPath.row];
    [cell setAllTypeOrder:item];
    return cell;
}

- (XYCompleteOrderCell*)getCompletedOrderCell:(NSIndexPath*)indexPath{
    XYCompleteOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYCompleteOrderCell defaultIdentifier]];
    cell.delegate = self;
    XYAllTypeOrderDto *item = [self.dataList objectAtIndex:indexPath.row];
    [cell setAllTypeOrderData:item];
    return cell;
}

- (XYClearedOrderCell*)getClearedOrderCell:(NSIndexPath*)indexPath{
    XYClearedOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYClearedOrderCell defaultIdentifier]];
    XYAllTypeOrderDto *item = [self.dataList objectAtIndex:indexPath.row];
    [cell setAllTypeOrder:item];
    return cell;
}

#pragma mark - action

- (void)callPhone:(UIButton*)btn{
    XYAllTypeOrderDto *item = [self.dataList objectAtIndex:btn.tag];
    [self.orderTableViewDelegate makePhoneCall:item.uMobile];
}

- (UIView*)emptyView{
    if (!_orderListEmptyView){
        _orderListEmptyView = [[UIView alloc]initWithFrame:self.bounds];
        _orderListEmptyView.backgroundColor = self.backgroundColor;
//        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 139)/2 , (self.bounds.size.height - 109)/2 - 20, 139, 109)];
//        imgView.image = [UIImage imageNamed:@"bg_no_order"];
//        [_orderListEmptyView addSubview:imgView];
        UILabel* noteLabel = [[UILabel alloc]init];
        noteLabel.textColor = LIGHT_TEXT_COLOR;
        noteLabel.font = SIMPLE_TEXT_FONT;
        noteLabel.text = @"暂无订单消息";
        CGSize size = [noteLabel.text sizeWithAttributes:@{NSFontAttributeName:SIMPLE_TEXT_FONT}];
//        noteLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, imgView.frame.size.height + imgView.frame.origin.y + 15, size.width, size.height);
        noteLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.bounds.size.height - size.height)/2, size.width, size.height);
        [_orderListEmptyView addSubview:noteLabel];
    }
    return _orderListEmptyView;
}

#pragma mark - swipe cell delegate

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{

    [cell hideUtilityButtonsAnimated:YES];
    NSIndexPath* path = [self indexPathForCell:cell];
    XYAllTypeOrderDto* item = [self.dataList objectAtIndex:path.row];
    
    if (item.type == XYAllOrderTypeRepair) {
        //有且只有维修订单有右滑技能
        if (item.status!=XYOrderStatusRepaired){
            [self.orderTableViewDelegate changeStatusOfOrder:item.id into:[XYOrderBase getClickedActionStatus:item.status rightBtnIndex:index] bid:item.bid];
        }else{
            //支付
            if (index == 0) {
                [self.orderTableViewDelegate payByCashOfOrder:item.id bid:item.bid];
            }else{
                [self.orderTableViewDelegate payByWorker:item.id bid:item.bid];
            }
        }
    }
}

#pragma mark - 更新维修订单item

- (void)updateRepairOrder:(XYOrderBase *)orderBase{
    
    for (XYAllTypeOrderDto* order in self.dataList) {
        //只有维修订单！
        if ((order.type == XYAllOrderTypeRepair) && [order.id isEqualToString:orderBase.id]) {
            XYAllTypeOrderDto* newOrder = [XYAllTypeOrderDto convertRepairOrder:orderBase from:order];
            [self replaceObjectWith:newOrder atIndex:[self.dataList indexOfObject:order]];
            break;
        }
    }
    [self reloadData];
}



@end
