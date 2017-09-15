//
//  XYCancelledOrdersViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/4/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCancelledOrdersViewController.h"
#import "XYOrderListTableView.h"
#import "XYOrderDetailViewController.h"
#import "XYAPIService.h"
#import "Masonry.h"
#import "NSDate+DateTools.h"

@interface XYCancelledOrdersViewController ()<XYTableViewWebDelegate,XYOrderListTableViewDelegate,XYOrderDetailDelegate>

@property(strong,nonatomic)XYOrderListTableView* tableView;
@end

@implementation XYCancelledOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initializeUIElements{
    //UI
    self.navigationItem.title = self.dateString;
    [self shouldShowBackButton:true];
    //
    self.tableView = [[XYOrderListTableView alloc]init];
    self.tableView.type = XYOrderListViewTypeDailyCancelled;
    [self.tableView setTableHeaderView:nil];
    self.tableView.backgroundColor = XY_COLOR(238,240,243);
    self.tableView.webDelegate=self;
    self.tableView.orderTableViewDelegate=self;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}


#pragma mark - tableView

- (void)goToAllOrderDetail:(NSString *)orderId type:(XYAllOrderType)type bid:(XYBrandType)bid{
   //...nothingtodo
}

- (void)goToCancelOrder:(NSString*)orderId bid:(XYBrandType)bid{
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
    orderDetailViewController.delegate = self;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}

- (void)onOrderStatusChanged:(XYOrderBase *)order{
  //
}


- (void)tableView:(XYBaseTableView*)tableView loadData:(NSInteger)p{
        __weak typeof(self) weakself = self;
        [[XYAPIService shareInstance] getCancelOrderByDay:self.dateString success:^(NSArray<XYCancelOrderDto *> *orderList) {
            [weakself hideLoadingMask];
            [weakself.tableView addListItems:orderList isRefresh:true withTotalCount:[orderList count]];
            [weakself updateTitleWithOrders:[orderList count]];
        }errorString:^(NSString *error){
            [weakself.tableView onLoadingFailed];
            [weakself hideLoadingMask];
            [weakself showToast:error];
        }];
}


#pragma mark - action

- (void)updateTitleWithOrders:(NSInteger)sum{
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%ld)",self.dateString,(long)sum];
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
