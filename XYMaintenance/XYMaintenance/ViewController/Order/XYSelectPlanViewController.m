//
//  XYSelectPlanViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectPlanViewController.h"
#import "XYSelectColorViewController.h"
#import "SimpleAlignCell.h"

@interface XYSelectPlanViewController ()<UITableViewDelegate,UITableViewDataSource,XYSelectColorDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSString* deviceId;
@property(strong,nonatomic)NSString* brandId;
@property(assign,nonatomic)XYBrandType bid;
@property(strong,nonatomic)NSArray* faultsArray;

@property(strong,nonatomic)NSString* allowedColorId;//指定展示颜色，没指定则显示全部
@property(assign,nonatomic)XYOrderType orderStatus;//是否限为售后订单
@end

@implementation XYSelectPlanViewController

- (id)initWithDevice:(NSString*)deviceId
               brand:(NSString*)brandId
                 bid:(XYBrandType)bid
        allowedColor:(NSString*)allowedColor
       editOrderType:(XYOrderType)orderStatus{
    if (self = [super init]){
        _deviceId = [deviceId copy];
        _brandId = [brandId copy];
        _bid = bid;
        _allowedColorId = allowedColor;
        _orderStatus = orderStatus;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getAllFaults];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property

- (NSArray*)faultsArray{
    if (!_faultsArray) {
        _faultsArray = [[NSArray alloc]init];
    }
    return _faultsArray;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:nil];
        [SimpleAlignCell xy_registerTableView:_tableView identifier:[SimpleAlignCell defaultReuseId]];
    }
    return _tableView;
}




#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择故障";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

- (void)getAllFaults{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getAllFaultsType:self.orderStatus success:^(NSArray *faultArray) {
        weakself.faultsArray = faultArray;
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
    } errorString:^(NSString *err) {
        [weakself hideLoadingMask];
        [weakself showToast:err];
    }];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.faultsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SimpleAlignCell* cell = [tableView dequeueReusableCellWithIdentifier:[SimpleAlignCell defaultReuseId]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.xyTextLabel.font = LARGE_TEXT_FONT;
    cell.xyTextLabel.textColor = BLACK_COLOR;
    cell.xyIndicator.hidden = false;
    XYLabelDto* dto = [self.faultsArray objectAtIndex:indexPath.row];
    cell.xyTextLabel.text = dto.Name;
    cell.xyDetailLabel.text = @"";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYLabelDto* dto = [self.faultsArray objectAtIndex:indexPath.row];
    XYSelectColorViewController* colorViewController = [[XYSelectColorViewController alloc]initWithDevice:self.deviceId brand:self.brandId fault:dto.Id bid:self.bid delegate:self allowedColor:self.allowedColorId orderType:self.orderStatus];
    [self.navigationController pushViewController:colorViewController animated:true];
}

- (void)onColorSelected:(NSString *)colorName colorId:(NSString *)colorId planId:(NSString *)planId planName:(NSString *)planName{
    if ([self.delegate respondsToSelector:@selector(onRepairingPlanSelected:color:colorId:repairType:)]) {
        [self.delegate onRepairingPlanSelected:planId color:colorName colorId:colorId repairType:planName];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
