//
//  XYSelectDeviceTypeViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectDeviceTypeViewController.h"
#import "XYSelectDeviceViewModel.h"
#import "XYSelectPlanViewController.h"

static NSString *const XYSelectDeviceBrandIdentifier = @"XYSelectDeviceBrandIdentifier";
static NSString *const XYSelectDeviceCellIdentifier = @"XYSelectDeviceCellIdentifier";

@interface XYSelectDeviceTypeViewController ()<UITableViewDataSource,UITableViewDelegate,XYSelectRepairingPlanDelegate>
//UI
@property(strong,nonatomic) UITableView* brandsListView;
@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) UISegmentedControl *segmentControl;
@property(strong,nonatomic) XYSelectDeviceViewModel* viewModel;
//data
@property(assign,nonatomic) id<XYSelectDeviceTypeDelegate> delegate;
@property(assign,nonatomic) XYOrderDeviceType type;
@property(assign,nonatomic) BOOL allowCustomDevice;//自定义机型
@property(strong,nonatomic) NSString* brandId;//指定brand
@property(strong,nonatomic) NSString* colorId;//指定color
//result
@property(strong,nonatomic) XYPHPDeviceDto* selectedMould;
@end

@implementation XYSelectDeviceTypeViewController

- (instancetype)initWithType:(XYOrderDeviceType)type
              allowCustomize:(BOOL)allowCustomDevice
                    delegate:(id<XYSelectDeviceTypeDelegate>)delegate
                allowedBrand:(NSString*)brandId
                allowedColor:(NSString*)colorId{
    if (self = [super init]) {
        self.type = type;
        self.allowCustomDevice = allowCustomDevice;
        self.delegate = delegate;
        self.brandId = brandId;
        self.colorId = colorId;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYSelectDeviceViewModel alloc]init];
    self.viewModel.brandId = self.brandId;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"选择机型";
    self.navigationItem.rightBarButtonItem = self.allowCustomDevice?[[UIBarButtonItem alloc]initWithTitle:@"自定义" style:UIBarButtonItemStylePlain target:self action:@selector(goToCustomDevice)]:nil;
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.brandsListView];
    [self.view addSubview:self.tableView];
}

#pragma mark - tableView

- (UISegmentedControl*)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"手机",@"平板"]];
        _segmentControl.frame = CGRectMake(90 + 15, 15, SCREEN_WIDTH - 90 - 2*15, 29);
        _segmentControl.tintColor = THEME_COLOR;
        [_segmentControl addTarget:self action:@selector(onSegSelected:) forControlEvents:UIControlEventValueChanged];
        _segmentControl.selectedSegmentIndex = 0;
        self.viewModel.currentBrandIndex = _segmentControl.selectedSegmentIndex;
    }
    return _segmentControl;
}

- (UITableView*)brandsListView{
    if(!_brandsListView){
        _brandsListView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,90, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _brandsListView.backgroundColor = WHITE_COLOR;
        _brandsListView.delegate = self;
        _brandsListView.dataSource = self;
        _brandsListView.separatorColor = XY_HEX(0xededed);
        _brandsListView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _brandsListView.bounces = false;
        [_brandsListView setTableHeaderView:[XYWidgetUtil getSingleLine]];
        [_brandsListView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_HEX(0xededed)]];
        if ([_brandsListView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_brandsListView setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_brandsListView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_brandsListView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _brandsListView;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(90, 2*15 + 29, SCREEN_WIDTH - 90, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - (2*15 + 29))];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
    }
    return _tableView;
}

- (XYInputCustomDeviceViewController*)customController{
    if (!_customController) {
        _customController = [[XYInputCustomDeviceViewController alloc]init];
    }
    return _customController;
}

#pragma mark - action

- (void)getDevices{
    [self showLoadingMask];
     __weak typeof(self) weakself = self;
    [self.viewModel getAllDevices:self.type success:^{
        [weakself hideLoadingMask];
        [weakself.brandsListView reloadData];
        [weakself.viewModel updateDevicesByBrandIndex:weakself.viewModel.currentBrandIndex andType:weakself.segmentControl.selectedSegmentIndex];
        [weakself.tableView reloadData];
    } errorString:^(NSString *e) {
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
}

- (void)goToCustomDevice{
    [self.navigationController pushViewController:self.customController animated:true];
}

- (void)onSegSelected:(UISegmentedControl*)seg{
    switch (seg.selectedSegmentIndex) {
        case XYSelectDeviceTypePhone:
        case XYSelectDeviceTypePad:
        {
            [self.viewModel updateDevicesByBrandIndex:self.viewModel.currentBrandIndex andType:seg.selectedSegmentIndex];
            [self.tableView reloadData];
        }
            break;
        default:
            break;
    }
}

#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.brandsListView]) {
        return [self.viewModel.brandsArray count];
    }else{
        return [self.viewModel.itemsArray count];
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.brandsListView]) {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYSelectDeviceBrandIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYSelectDeviceBrandIdentifier];
            cell.textLabel.textColor = BLACK_COLOR;
            cell.textLabel.font = SIMPLE_TEXT_FONT;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        NSString* brandName = [self.viewModel.brandsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = brandName;
        cell.contentView.backgroundColor = (self.viewModel.currentBrandIndex == indexPath.row)?WHITE_COLOR:XY_HEX(0xf9f9f9);
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYSelectDeviceCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XYSelectDeviceCellIdentifier];
            cell.textLabel.textColor = BLACK_COLOR;
            cell.textLabel.font = LARGE_TEXT_FONT;
        }
        XYPHPDeviceDto* dto = [self.viewModel.itemsArray objectAtIndex:indexPath.row];
        cell.textLabel.text =[NSString stringWithFormat:@" %@",dto.MouldName];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if ([tableView isEqual:self.brandsListView]) {
        self.viewModel.currentBrandIndex = indexPath.row;
        [tableView reloadData];
        [self.viewModel updateDevicesByBrandIndex:self.viewModel.currentBrandIndex andType:self.segmentControl.selectedSegmentIndex];
        [self.tableView reloadData];
    }else{
        XYPHPDeviceDto* dto = [self.viewModel.itemsArray objectAtIndex:indexPath.row];
        if (![XYStringUtil isNullOrEmpty:self.brandId]) {
            //如果指定了brand，还要去选方案
            self.selectedMould = dto;
            [self goToEditPlan];
        }else{
            if ([self.delegate respondsToSelector:@selector(onDeviceSelected:color:newPlan:)]) {
                [self.delegate onDeviceSelected:dto color:nil newPlan:nil];
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)goToEditPlan{
    XYSelectPlanViewController* selectPlanViewController = [[XYSelectPlanViewController alloc]initWithDevice:self.selectedMould.Id brand:self.selectedMould.BrandId bid:self.selectedMould.bid allowedColor:self.colorId editOrderType:XYOrderTypeNormal];
    selectPlanViewController.delegate = self;
    [self.navigationController pushViewController:selectPlanViewController animated:true];
}

- (void)onRepairingPlanSelected:(NSString *)planId color:(NSString *)colorName colorId:(NSString *)colorId repairType:(NSString *)planDescription{
    if ([self.delegate respondsToSelector:@selector(onDeviceSelected:color:newPlan:)]) {
        [self.delegate onDeviceSelected:self.selectedMould color:colorId newPlan:planId];
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
