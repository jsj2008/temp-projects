//
//  XYCompleteOrderViewController.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBaseViewController.h"
#import "XYOrderListManager.h"
#import "SKSTableView.h"
@interface XYCompleteOrderViewController : XYBaseViewController
@property(assign,nonatomic)id<XYOrderListTableViewDelegate> orderTableViewDelegate;
@property (weak, nonatomic) IBOutlet SKSTableView *tableView;
- (void)loadData;
@property (nonatomic,copy) void (^resetTitleCountBlock)(NSInteger totalCount);
@end
