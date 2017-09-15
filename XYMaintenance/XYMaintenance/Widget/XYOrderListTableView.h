//
//  XYOrderListTableView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseTableView.h"
#import "XYOrderListCell.h"
#import "XYCancelOrderCell.h"
#import "XYOrderListManager.h"

/**
 *  纯维修订单列表tableView
 */
@interface XYOrderListTableView : XYBaseTableView<UITableViewDataSource,UITableViewDelegate,SWTableViewCellDelegate>

@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;
@property(assign,nonatomic)XYRepairOrderListViewType type;

//更新单个订单
- (void)updateOrder:(XYOrderBase*)order;

@end
