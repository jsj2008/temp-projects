//
//  XYRecyclePaymentViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecyclePaymentViewController.h"
#import "XYOrderDetailTopCell.h"
#import "XYCustomButton.h"
#import "UIControl+XYButtonClickDelayer.h"


@interface XYRecyclePaymentViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet XYCustomButton *submitButton;
@end

@implementation XYRecyclePaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

//- (void)initializeData{
//    self.paySelectionArray = @[@"公司支付",@"工程师垫付(现金)",@"工程师垫付(微信)",@"工程师垫付(支付宝)"];
//    self.currentSelection = -1;
//}

- (void)initializeUIElements{
    self.navigationItem.title = @"付款确认";
    
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = false;
    [self.tableView setTableHeaderView:nil];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
    
    self.submitButton.uxy_acceptEventInterval = 2.0;
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return [self getTopCell];
        case 1:
            return [self getSimpleCell];
        default:
            return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
//    if (indexPath.section == 1) {
//        self.currentSelection = indexPath.row;
//        [self.tableView reloadData];
//    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LINE_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - cell

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = XY_NOTNULL(self.viewModel.orderDetail.mould_name, @"回收设备");
    topCell.statusLabel.text = [NSString stringWithFormat:@"最终价格：￥%@",@(self.viewModel.orderDetail.price)];
    return topCell;
}

- (XYOrderDetailTopCell*)getSimpleCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.selectionStyle = UITableViewCellSelectionStyleNone;
    topCell.orderIdLabel.text = @"支付方式";
    topCell.statusLabel.text = self.viewModel.orderDetail.payTypeStr;
    return topCell;
}

//- (XYCancelReasonCell*)getSelectionCellByPath:(NSIndexPath*)path{
//    XYCancelReasonCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[XYCancelReasonCell defaultReuseId]];
//    [cell setXYSelected:(path.row == self.currentSelection)];
//    cell.reasonLabel.text = [self.paySelectionArray objectAtIndex:path.row];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
//}


#pragma mark - action

- (IBAction)confirmPayment:(id)sender {
    [self showLoadingMask];
    self.viewModel.delegate = self;
    [self.viewModel submitOrder];
}

- (void)popToMainPage{
    [self.navigationController popToRootViewControllerAnimated:true];
}

- (void)onOrderSubmitted:(BOOL)success orderId:(NSString*)orderId noteString:(NSString*)errorString{
    [self hideLoadingMask];
    if (success) {
        [self postRefreshNotification];
        [self performSelector:@selector(popToMainPage) withObject:nil afterDelay:3.0];
        [self showToast:[NSString stringWithFormat:@"创建回收订单成功！\n订单号：%@",orderId]];
    }else{
        [self showToast:errorString];
    }
}

- (void)postRefreshNotification{
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_OLD_ORDER object:nil];
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
