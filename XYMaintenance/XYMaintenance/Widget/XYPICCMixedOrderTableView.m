//
//  XYPICCMixedOrderTableView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/5.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCMixedOrderTableView.h"
#import "XYConfig.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "NSDate+DateTools.h"

@interface XYPICCMixedOrderTableView (){
    UIView* _orderListEmptyView;
}
@end

@implementation XYPICCMixedOrderTableView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.dataSource = self;
        self.delegate = self;
        self.type = XYPICCMixedOrderListViewTypeUnknown;
    }
    return self;
}

- (void)setType:(XYPICCMixedOrderListViewType)type{
    _type = type;
    switch (type) {
        case XYPICCMixedOrderListViewTypeIncomplete:
            [XYIncompleteOrderCell xy_registerTableView:self identifier:[XYIncompleteOrderCell defaultIdentifier]];
            break;
        case XYPICCMixedOrderListViewTypeCompleted:
            [XYCompleteOrderCell xy_registerTableView:self identifier:[XYCompleteOrderCell defaultIdentifier]];
            break;
        case XYPICCMixedOrderListViewTypeUnknown:
            break;
        default:
            break;
    }
}

#pragma mark - property

- (NSMutableArray*)abandonedPiccOrderList{
    if (!_abandonedPiccOrderList) {
        _abandonedPiccOrderList = [[NSMutableArray alloc]init];
    }
    return _abandonedPiccOrderList;
}

- (NSMutableDictionary*)relatedPiccOrderDic{
    if (!_relatedPiccOrderDic) {
        _relatedPiccOrderDic = [[NSMutableDictionary alloc]init];
    }
    return _relatedPiccOrderDic;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    switch (self.type) {
        case XYPICCMixedOrderListViewTypeUnknown:
            return 0;
        case XYPICCMixedOrderListViewTypeIncomplete:
        case XYPICCMixedOrderListViewTypeCompleted:
            return 1 + [self.dataList count];
        default:
            return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (self.type) {
        case XYPICCMixedOrderListViewTypeUnknown:
            return 0;
        case XYPICCMixedOrderListViewTypeIncomplete:
        case XYPICCMixedOrderListViewTypeCompleted:
        {
            if (section == 0) {
                return [self.abandonedPiccOrderList count];
            }else{
                return [self getMixedRowsCountBySection:section];
            }
        }
        default:
            return 0;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYPICCMixedOrderListViewTypeUnknown:
            return 0;
        case XYPICCMixedOrderListViewTypeIncomplete:
            return [self getInCompleteOrderCell:indexPath];
        case XYPICCMixedOrderListViewTypeCompleted:
            return [self getCompletedOrderCell:indexPath];
        default:
            return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.type) {
        case XYPICCMixedOrderListViewTypeUnknown:
            return 0;
        case XYPICCMixedOrderListViewTypeIncomplete:
            return [XYIncompleteOrderCell getHeight];
        case XYPICCMixedOrderListViewTypeCompleted:
            return [XYCompleteOrderCell getHeight];
        default:
            return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (self.type) {
        case XYPICCMixedOrderListViewTypeUnknown:
            return;
        case XYPICCMixedOrderListViewTypeIncomplete:
        case XYPICCMixedOrderListViewTypeCompleted:
        {
            if (indexPath.section == 0) {
                XYOrderBase* order = [self.abandonedPiccOrderList objectAtIndex:indexPath.row];
                [self.orderTableViewDelegate goToPICCOrder:order.picc_odd_number];
            }else{
                XYOrderBase* orignalOrder = [self.dataList objectAtIndex:indexPath.section-1];
                if (indexPath.row == 0) {
                    [self.orderTableViewDelegate goToOrderDetail:orignalOrder];
                }else{
                    NSArray* array = [self.relatedPiccOrderDic objectForKey:orignalOrder.id];
                    if (array == nil || [array count]==0) {
                        //just like this
                    }else{
                        XYOrderBase* piccOrder = [array objectAtIndex:indexPath.row-1];
                        [self.orderTableViewDelegate goToPICCOrder:piccOrder.picc_odd_number];
                    }
                }
            }
        }
        default:
            return ;
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

- (NSInteger)getMixedRowsCountBySection:(NSInteger)section{
    XYOrderBase* order = [self.dataList objectAtIndex:section-1];//section0都是无关联订单，所以从1算起
    NSArray* array = [self.relatedPiccOrderDic objectForKey:order.id];//用订单id查保险订单数组
    if (array==nil || [array count]==0) {
        return 1;//没有保险订单
    }
    return 1 + [array count];//有保险订单
}


- (XYIncompleteOrderCell*)getInCompleteOrderCell:(NSIndexPath*)indexPath{
    XYIncompleteOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYIncompleteOrderCell defaultIdentifier]];
    [cell.phoneCallButton addTarget:self action:@selector(callPhone:) forControlEvents:UIControlEventTouchUpInside];
    cell.phoneCallButton.tag = indexPath.section*10+indexPath.row;
    cell.delegate = self;
    if (indexPath.section == 0) {//无关联的订单
        XYOrderBase* orderBase = [self.abandonedPiccOrderList objectAtIndex:indexPath.row];
        [cell setPICCOrderData:orderBase];
    }else{//有关联的订单 每个section:
        XYOrderBase* orderBase = [self.dataList objectAtIndex:(indexPath.section - 1)];
        if(indexPath.row == 0){//row0 是该section的原始订单
           [cell setRepairOrderData:orderBase];
        }else{//保险订单
            NSArray* array = [self.relatedPiccOrderDic objectForKey:orderBase.id];
            if (array==nil || [array count]==0) {
                //just like this
            }else{
               XYOrderBase* piccOrder = [array objectAtIndex:indexPath.row-1];
               [cell setPICCOrderData: piccOrder] ;
            }
        }
    }
    return cell;
}

- (XYCompleteOrderCell*)getCompletedOrderCell:(NSIndexPath*)indexPath{
    XYCompleteOrderCell* cell = [self dequeueReusableCellWithIdentifier:[XYCompleteOrderCell defaultIdentifier]];
    cell.delegate = self;
    if (indexPath.section == 0) {//无关联的订单
        XYOrderBase* orderBase = [self.abandonedPiccOrderList objectAtIndex:indexPath.row];
        [cell setPICCOrderData:orderBase];
    }else{//有关联的订单 每个section:
        XYOrderBase* orderBase = [self.dataList objectAtIndex:(indexPath.section - 1)];
        if(indexPath.row == 0){//row0 是该section的原始订单
            [cell setRepairOrderData:orderBase];
        }else{//保险订单
            NSArray* array = [self.relatedPiccOrderDic objectForKey:orderBase.id];
            if (array==nil || [array count]==0) {
                //just like this
            }else{
                XYOrderBase* piccOrder = [array objectAtIndex:indexPath.row-1];
                [cell setPICCOrderData: piccOrder] ;
            }
        }
    }
    return cell;
}

#pragma mark - action

- (void)reOrderPICCMixedOrderList{
    NSMutableArray* abandonArray = [[NSMutableArray alloc]init];
    for (NSString* key in self.relatedPiccOrderDic) {
        if ([key isEqualToString:@""]) {//无关联的，直接添加
            [abandonArray addObjectsFromArray:[self.relatedPiccOrderDic objectForKey:key]];
        }else{
            BOOL findOrginalOrder = false;
            for (XYOrderBase* orderBase in self.dataList) {
                if ([key isEqualToString:orderBase.id]) {
                    findOrginalOrder = true;
                    break;
                }
            }
            if(!findOrginalOrder){//本地没有ta的原始订单 也是abandon
               [abandonArray addObjectsFromArray:[self.relatedPiccOrderDic objectForKey:key]];
            }
        }
    }
    [self.abandonedPiccOrderList removeAllObjects];
    [self.abandonedPiccOrderList addObjectsFromArray:abandonArray];
    [self reloadData];
}

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
    XYOrderBase* orderBase = [self.dataList objectAtIndex:path.section - 1];
    
    if (orderBase.status!=XYOrderStatusRepaired){
        [self.orderTableViewDelegate changeStatusOfOrder:orderBase.id into:[XYOrderBase getClickedActionStatus:orderBase.status rightBtnIndex:index]];
    }else{
        if (index == 0) {//取消现金支付
            [self.orderTableViewDelegate payByCashOfOrder:orderBase.id];
        }else{
            [self.orderTableViewDelegate payByWorker:orderBase.id];
        }
    }
}

- (void)callPhone:(UIButton*)btn{

       //fuck picc
    
    NSInteger section = btn.tag/10;
    NSInteger row = btn.tag%10;
    
    if (section == 0) {
        XYOrderBase* order = [self.abandonedPiccOrderList objectAtIndex:row];
        [self.orderTableViewDelegate makePhoneCall:order.uMobile];
    }else{
        XYOrderBase* orignalOrder = [self.dataList objectAtIndex:section-1];
        if (row == 0) {
            [self.orderTableViewDelegate makePhoneCall:orignalOrder.uMobile];
        }else{
            NSArray* array = [self.relatedPiccOrderDic objectForKey:orignalOrder.id];
            if (array == nil || [array count]==0) {
                //just like this
            }else{
                XYOrderBase* piccOrder = [array objectAtIndex:row-1];
                [self.orderTableViewDelegate makePhoneCall:piccOrder.uMobile];
            }
        }
    }
}


- (void)reloadData{
    
    [super reloadData];
    
    if ([self.dataList count]>0 || [self.abandonedPiccOrderList count]>0){
        [self removeEmptyView];
    }else{
        [self showEmptyView];
    }
}

-(UIView*)emptyView{
    if (!_orderListEmptyView){
        _orderListEmptyView = [[UIView alloc]initWithFrame:self.bounds];
        _orderListEmptyView.backgroundColor = self.backgroundColor;
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth - 139)/2 , (self.bounds.size.height - 109)/2 - 20, 139, 109)];
        imgView.image = [UIImage imageNamed:@"bg_no_order"];
        [_orderListEmptyView addSubview:imgView];
        UILabel* noteLabel = [[UILabel alloc]init];
        noteLabel.textColor = LIGHT_TEXT_COLOR;
        noteLabel.font = SIMPLE_TEXT_FONT;
        noteLabel.text = @"暂无订单消息";
        CGSize size = [noteLabel.text sizeWithAttributes:@{NSFontAttributeName:SIMPLE_TEXT_FONT}];
        noteLabel.frame = CGRectMake((ScreenWidth - size.width)/2, imgView.frame.size.height + imgView.frame.origin.y + 15, size.width, size.height);
        [_orderListEmptyView addSubview:noteLabel];
    }
    return _orderListEmptyView;
}



@end
