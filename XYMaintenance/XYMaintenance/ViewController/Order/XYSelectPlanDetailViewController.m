//
//  XYSelectPlanDetailViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectPlanDetailViewController.h"
#import "XYPlanDetailCell.h"

@interface XYSelectPlanDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(assign,nonatomic) id<XYSelectPlanDetailDelegate> delegate;
@property(copy,nonatomic) NSString* deviceId;
@property(copy,nonatomic) NSString* brandId;
@property(copy,nonatomic) NSString* faultId;
@property(copy,nonatomic) NSString* colorId;
@property(assign,nonatomic) XYOrderType orderStatus;

@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) NSMutableArray* plansArray;
@end

@implementation XYSelectPlanDetailViewController

- (instancetype)initWithDelegate:(id<XYSelectPlanDetailDelegate>)delegate device:(NSString *)deviceId brand:(NSString *)brandId fault:(NSString *)faultId color:(NSString *)colorId orderType:(XYOrderType)orderStatus{
    if(self = [super init]){
        _delegate = delegate;
        _deviceId = [deviceId copy];
        _brandId = [brandId copy];
        _faultId = [faultId copy];
        _colorId = [colorId copy];
        _orderStatus = orderStatus;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getPlansArray];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择方案";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

- (NSMutableArray*)plansArray{
    if (!_plansArray) {
        _plansArray = [[NSMutableArray alloc]init];
    }
    return _plansArray;
}

- (UITableView*)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:nil];
        [_tableView setTableHeaderView:nil];
    }
    return _tableView;
}

- (void)getPlansArray{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getRepairingPlanOfDevice:self.deviceId fault:self.faultId color:self.colorId orderStatus:self.orderStatus success:^(NSArray *plansArray){
         [weakself.plansArray removeAllObjects];
        for (XYPlanDto* plan in plansArray) {
            plan.cellHeight = [XYPlanDetailCell getCellHeightOfRepairType:plan.RepairType];
            [self.plansArray addObject:plan];
        }
        [weakself hideLoadingMask];
        [weakself.tableView reloadData];
     }errorString:^(NSString *errorString){
         [weakself hideLoadingMask];
         [weakself showToast:errorString];
     }];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.plansArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYPlanDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYPlanDetailCell defaultReuseId]];
    if (!cell) {
        cell = [[XYPlanDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[XYPlanDetailCell defaultReuseId]];
    }
    XYPlanDto* dto = [self.plansArray objectAtIndex:indexPath.row];
    [cell setData:dto];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYPlanDto* dto = [self.plansArray objectAtIndex:indexPath.row];
    return dto.cellHeight + 125.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYPlanDto* dto = [self.plansArray objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(onPlanDetailSelected:descrption:)]) {
        [self.delegate onPlanDetailSelected:dto.Id descrption:dto.RepairType];
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
