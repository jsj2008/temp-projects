//
//  XYPICCMixedOrderTableView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/5.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseTableView.h"
#import "XYOrderListManager.h"
#import "XYIncompleteOrderCell.h"
#import "XYCompleteOrderCell.h"

typedef NS_ENUM(NSInteger, XYPICCMixedOrderListViewType) {
    XYPICCMixedOrderListViewTypeUnknown = -1,
    XYPICCMixedOrderListViewTypeIncomplete = 1, //未完成
    XYPICCMixedOrderListViewTypeCompleted = 2,//已完成
};

@interface XYPICCMixedOrderTableView : XYBaseTableView<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>
@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;
@property(assign,nonatomic)XYPICCMixedOrderListViewType type;

@property(strong,nonatomic) NSMutableArray* abandonedPiccOrderList;
@property(strong,nonatomic) NSMutableDictionary* relatedPiccOrderDic;

- (void)reOrderPICCMixedOrderList;
- (void)updateOrder:(XYOrderBase*)order;


//- (void)updatePICCOrder:(XYOrderBase*)order; //不要更新picc订单，直接刷

@end


