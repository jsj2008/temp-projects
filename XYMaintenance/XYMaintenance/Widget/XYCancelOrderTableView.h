//
//  XYCancelOrderTableView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/4/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOrderListManager.h"

@interface XYCancelOrderTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;

@property(strong,nonatomic)NSArray* ordersList;
@property(strong,nonatomic)NSArray* daysList;

- (void)updateCancelledOrders;

@end
