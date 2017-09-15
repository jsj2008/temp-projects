//
//  XYCompleteDailyOrderViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/23.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYClearDailyOrderViewController.h"
#import "XYAllOrdersTableView.h"
#import "XYOrderDetailViewController.h"
#import "XYPICCOrderDetailViewController.h"
#import "XYAPIService+V4API.h"
#import "XYAPIService.h"
#import "Masonry.h"
#import "NSDate+DateTools.h"
#import "XYRecycleOrderDetailViewController.h"
#import "SDTrackTool.h"

@interface XYClearDailyOrderViewController ()<XYTableViewWebDelegate,XYOrderListTableViewDelegate>

@property(strong,nonatomic)XYAllOrdersTableView* tableView;
@property(strong,nonatomic)NSString* completeDateStr; //format:@"20150101"

@end

@implementation XYClearDailyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self.tableView refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUIElements{
    //UI
    self.navigationItem.title = self.titleStr;
    [self shouldShowBackButton:true];
    self.completeDateStr = self.titleStr;
    //
    self.tableView = [[XYAllOrdersTableView alloc]init];
    self.tableView.type = XYAllOrderListViewTypeCleared;
    [self.tableView setTableHeaderView:nil];
    self.tableView.backgroundColor = XY_COLOR(238,240,243);
    self.tableView.webDelegate=self;
    self.tableView.orderTableViewDelegate=self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - property

- (NSMutableArray*)completeOrderList{
    if (!_completeOrderList) {
        _completeOrderList = [[NSMutableArray alloc]init];
    }
    return _completeOrderList;
}

#pragma mark - tableView

- (void)goToAllOrderDetail:(NSString *)orderId type:(XYAllOrderType)type bid:(XYBrandType)bid{
    [SDTrackTool logEvent:@"PAGE_EVENT_XYOrderDetailViewController_CLEAR"];
    switch (type) {
        case XYAllOrderTypeRepair:
            [self goToRepairOrderDetail:orderId bid:bid];
            break;
        case XYAllOrderTypeInsurance:
            [self goToPICCOrder:orderId];
            break;
        case XYAllOrderTypeRecycle:
            [self goToRecycleOrder:orderId];
            break;
        default:
            break;
    }
}
//维修订单详情
- (void)goToRepairOrderDetail:(NSString*)orderId bid:(XYBrandType)bid{
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}

//保险订单详情
- (void)goToPICCOrder:(NSString *)odd_number{
    XYPICCOrderDetailViewController* orderDetailViewController = [[XYPICCOrderDetailViewController alloc]init];
    orderDetailViewController.odd_number = odd_number;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}
//回收订单详情
- (void)goToRecycleOrder:(NSString *)orderId{
    XYRecycleOrderDetailViewController* orderDetailViewController = [[XYRecycleOrderDetailViewController alloc]init];
    orderDetailViewController.orderId = orderId;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}


- (void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p{
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getAllClearOrderList:self.completeDateStr page:p success:^(NSArray<XYAllTypeOrderDto *> *orderList, NSInteger sum) {
        [weakself hideLoadingMask];
        [weakself.tableView addListItems:orderList isRefresh:(p==1) withTotalCount:sum];
        [weakself updateTitleWithOrders:sum];
    } errorString:^(NSString *error) {
        [weakself.tableView onLoadingFailed];
        [weakself hideLoadingMask];
        [weakself showToast:error];
    }];
}

#pragma mark - action

- (void)updateTitleWithOrders:(NSInteger)sum{
   self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",self.titleStr,(long)sum];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
