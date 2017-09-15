//
//  XYOrderDaysTableView.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderListManager.h"

@interface XYOrderDaysTableView : UITableView<UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;

@property(strong,nonatomic)NSArray* todayOrderList;//今天的结算订单
@property(strong,nonatomic)NSArray* daysList;//日期列表 //nsdate

- (void)refresh;
- (void)reset;

@end
