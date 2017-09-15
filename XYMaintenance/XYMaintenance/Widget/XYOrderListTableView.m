//
//  XYOrderListTableView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListTableView.h"
#import "XYConfig.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "NSDate+DateTools.h"

@interface XYOrderListTableView (){
    UIView* _orderListEmptyView;
}
@end

@implementation XYOrderListTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        self.type = XYOrderListViewTypeUnknown;
    }
    return self;
}

- (void)setType:(XYRepairOrderListViewType)type{
    _type = type;
    switch (type) {
        case XYOrderListViewTypeSearch:
            [XYOrderListCell xy_registerTableView:self identifier:[XYOrderListCell defaultReuseId]];
            break;
        case XYOrderListViewTypeDailyCancelled:
            [XYCancelOrderCell xy_registerTableView:self identifier:[XYCancelOrderCell defaultReuseId]];
            break;
        default:
            break;
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.type) {
       case XYOrderListViewTypeSearch:
       case XYOrderListViewTypeDailyCancelled:
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
        case XYOrderListViewTypeSearch:
            return [self getOrderListCell:indexPath];
            break;
        case XYOrderListViewTypeDailyCancelled:
            return [self getCancelledOrderCell:indexPath];
            break;
        default:
            return nil;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type==XYOrderListViewTypeSearch) {
        return [XYOrderListCell defaultHeight];
    }else if(self.type == XYOrderListViewTypeDailyCancelled){
        return [XYCancelOrderCell getHeight];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (self.type == XYOrderListViewTypeDailyCancelled) {
        //取消订单的结构比较特别恩
        XYCancelOrderDto* cancelOrder = [self.dataList objectAtIndex:indexPath.row];
        [self.orderTableViewDelegate goToCancelOrder:cancelOrder.order_id bid:cancelOrder.bid];
    }else{
        XYOrderBase *item = [self.dataList objectAtIndex:indexPath.row];
        [self.orderTableViewDelegate goToAllOrderDetail:item.id type:XYAllOrderTypeRepair bid:item.bid];
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

- (XYOrderListCell*)getOrderListCell:(NSIndexPath*)indexPath{
    //搜索页面不用滑动了
    XYOrderListCell* cell = [self dequeueReusableCellWithIdentifier:[XYOrderListCell defaultReuseId]];
    [cell setData:[self.dataList objectAtIndex:indexPath.row]];
    return cell;
}

- (XYCancelOrderCell*)getCancelledOrderCell:(NSIndexPath*)indexPath{
    XYCancelOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYCancelOrderCell defaultReuseId]];
    [cell setData:[self.dataList objectAtIndex:indexPath.row] type:false];
    return cell;
}

#pragma mark - action

- (void)updateOrder:(XYOrderBase*)newOrder{
    for (XYOrderBase* order in self.dataList) {
        if ([order.id isEqualToString:newOrder.id]) {
            [self replaceObjectWith:newOrder atIndex:[self.dataList indexOfObject:order]];
            break;
        }
    }
    [self reloadData];
}

#pragma mark - swipe cell delegate

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell{
    return YES;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index{
    [cell hideUtilityButtonsAnimated:YES];
    NSIndexPath* path = [self indexPathForCell:cell];
    XYOrderBase* orderBase = [self.dataList objectAtIndex:path.row];
    if (orderBase.status!=XYOrderStatusRepaired){
        [self.orderTableViewDelegate changeStatusOfOrder:orderBase.id into:[XYOrderBase getClickedActionStatus:orderBase.status rightBtnIndex:index] bid:orderBase.bid];
    }else{//维修完成
        if (index == 0) {//现金支付
           [self.orderTableViewDelegate payByCashOfOrder:orderBase.id bid:orderBase.bid];
        }else{//代付
           [self.orderTableViewDelegate payByWorker:orderBase.id bid:orderBase.bid];
        }
    }
}

- (void)callPhone:(UIButton*)btn{
    XYOrderBase *item = [self.dataList objectAtIndex:btn.tag];
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
        noteLabel.text = (self.type==XYOrderListViewTypeSearch) ? @"暂无搜索结果" : @"暂无订单消息";
        CGSize size = [noteLabel.text sizeWithAttributes:@{NSFontAttributeName:SIMPLE_TEXT_FONT}];
//        noteLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, imgView.frame.size.height + imgView.frame.origin.y + 15, size.width, size.height);
        noteLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/2, (self.bounds.size.height - size.height)/2, size.width, size.height);
        [_orderListEmptyView addSubview:noteLabel];
    }
    return _orderListEmptyView;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
