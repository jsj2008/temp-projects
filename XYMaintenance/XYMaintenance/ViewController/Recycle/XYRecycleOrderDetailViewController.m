//
//  XYRecycleOrderDetailViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/8.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleOrderDetailViewController.h"
#import "XYOrderDetailTopCell.h"
#import "SimpleAlignCell.h"
#import "XYRecycleEvaluationViewController.h"
#import "XYRecycleOrderDetailViewModel.h"
#import "XYCustomButton.h"
#import "XYRecycleSelectDeviceViewController.h"
#import "XYTargetLocationViewController.h"

@interface XYRecycleOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,XYRecycleOrderDetailCallBackDelegate,XYRecycleDeviceDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonPanelHeight;
@property (weak, nonatomic) IBOutlet UIView *buttonPanel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet XYCustomButton *actionButton;

@property (strong, nonatomic)XYRecycleOrderDetailViewModel* viewModel;

@end

@implementation XYRecycleOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self loadOrderDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYRecycleOrderDetailViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"订单详情";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = TABLE_DEVIDER_COLOR;
    [self.tableView setTableHeaderView:nil];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)]];
    [XYOrderDetailTopCell xy_registerTableView:self.tableView identifier:[XYOrderDetailTopCell defaultReuseId]];
    [SimpleAlignCell xy_registerTableView:self.tableView identifier:[SimpleAlignCell defaultReuseId]];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (![self.viewModel isBeforeOrderDone]) {
        return 3;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(NSArray*)[self.viewModel.titleArray objectAtIndex:section] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [self getTopCell];
    }else{
        return [self getSimpleCellForIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return LINE_HEIGHT;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [XYWidgetUtil getSingleLineWithColor:XY_COLOR(194,205,218)];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:false];
    XYRecycleOrderDetailCellType type = [self.viewModel getCellTypeByPath:indexPath];
    if (type == XYRecycleOrderDetailCellTypeDevice) {
        if ([self.viewModel isBeforeOrderDone]) {
            [self goToEditDevice];
        }
    }else if(type == XYRecycleOrderDetailCellTypePhone){
        [self makePhoneCall];
    }else if(type == XYRecycleOrderDetailCellTypeFullAddress){
        [self goToRouteGuidance];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}


#pragma mark - cell

- (XYOrderDetailTopCell*)getTopCell{
    XYOrderDetailTopCell* topCell = [self.tableView dequeueReusableCellWithIdentifier:[XYOrderDetailTopCell defaultReuseId]];
    topCell.orderIdLabel.text = [NSString stringWithFormat:@"订单 %@",XY_NOTNULL(self.viewModel.orderDetail.id,@"")];
    topCell.statusLabel.text = self.viewModel.orderDetail.statusStr;
    return topCell;
}

- (SimpleAlignCell*)getSimpleCellForIndexPath:(NSIndexPath *)indexPath{
    SimpleAlignCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = SIMPLE_TEXT_FONT;
    cell.xyTextLabel.textColor = LIGHT_TEXT_COLOR;
    cell.xyDetailLabel.font = SIMPLE_TEXT_FONT;
    cell.xyDetailLabel.adjustsFontSizeToFitWidth = true;
    
    cell.xyDetailLabel.textColor = [self.viewModel shouldHightLight:indexPath]?BLUE_COLOR:BLACK_COLOR;
    cell.xyTextLabel.text = XY_NOTNULL([self.viewModel getTitleByPath:indexPath],@"");
    cell.xyDetailLabel.text = XY_NOTNULL([self.viewModel getContentByPath:indexPath],@"");
    cell.xyIndicator.hidden = ![self.viewModel getSelectableByType:[self.viewModel getCellTypeByPath:indexPath]];
    return cell;
}

#pragma mark - action

- (IBAction)buttonClicked:(id)sender {
    switch (self.viewModel.orderDetail.status) {
        case XYRecycleOrderStatusCreated:
        case XYRecycleOrderStatusAssigned:
            [self setOff];
            break;
        case XYRecycleOrderStatusSetOff:
            [self goToConfirmInfo];
            break;
        default:
            break;
    }
}

- (void)loadOrderDetail{
    [self showLoadingMask];
    [self.viewModel loadOrderDetail:self.orderId];
}

- (void)setOff{
    [XYAlertTool showConfirmCancelAlert:@"确定出发？" message:nil onView:self action:^{
        [self showLoadingMask];
        [self.viewModel setOff];
    } cancel:nil];
}

- (void)goToEditDevice{
    XYRecycleSelectDeviceViewController* deviceViewController = [[XYRecycleSelectDeviceViewController alloc]init];
    deviceViewController.delegate = self;
    [self.navigationController pushViewController:deviceViewController animated:true];
}

- (void)goToConfirmInfo{
    XYRecycleEvaluationViewController* evalutationViewController = [[XYRecycleEvaluationViewController alloc]init];
    evalutationViewController.preOrderDetail = self.viewModel.orderDetail;
    [self.navigationController pushViewController:evalutationViewController animated:true];
}

- (void)makePhoneCall{
    [XYAlertTool callPhone:self.viewModel.orderDetail.user_mobile onView:self];
}

- (void)goToRouteGuidance{
    if ([XYStringUtil isNullOrEmpty:_viewModel.orderDetail.address]) {
        [self showToast:TT_NO_ADDRESS];
        return;
    }
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.viewModel.orderDetail.address];
    XYTargetLocationViewController* mapLocationViewController = [[XYTargetLocationViewController alloc]initWithTargetAddress:self.viewModel.orderDetail.address area:self.viewModel.orderDetail.city_name];
    [self.navigationController pushViewController:mapLocationViewController animated:true];
}

- (void)resetButtonPanel{
    if (self.viewModel.orderDetail.buttonTitleStr) {
        [self.actionButton setTitle:self.viewModel.orderDetail.buttonTitleStr forState:UIControlStateNormal];
        self.actionButton.hidden = false;
        self.buttonPanelHeight.constant = 60;
    }else{
        self.actionButton.hidden = true;
        self.buttonPanelHeight.constant = 0;
    }
}

#pragma mark - delegate

- (void)onOrderLoaded:(BOOL)success noteString:(NSString *)errorString{
    [self hideLoadingMask];
    [self.tableView reloadData];
    [self resetButtonPanel];
}

- (void)onSetOff:(BOOL)success noteString:(NSString *)errorString{
    [self hideLoadingMask];
    if (success) {
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
        [self loadOrderDetail];
    }else{
        [self showToast:errorString];
    }
}

- (void)onDeviceSelected:(XYRecycleDeviceDto *)device{
    self.viewModel.orderDetail.mould_id = device.Id;
    self.viewModel.orderDetail.mould_name = device.MouldName;
    [self.tableView reloadData];
    [self.navigationController popToViewController:self animated:true];
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
