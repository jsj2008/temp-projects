//
//  XYAllOrdersTableView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/15.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseTableView.h"
#import "XYOrderListManager.h"
#import "XYAllTypeOrderDto.h"
#import "XYIncompleteOrderCell.h"
#import "XYCompleteOrderCell.h"
#import "XYClearedOrderCell.h"


@interface XYAllOrdersTableView : XYBaseTableView<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;
@property(assign,nonatomic)XYAllOrderListViewType type;

//更新单个维修订单item
- (void)updateRepairOrder:(XYOrderBase*)orderBase;

@end
