//
//  XYPartDeviceViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartDeviceViewController.h"
#import "XYSelectDeviceViewModel.h"
#import "XYPartFaultViewController.h"

static NSString *const XYPartDeviceBrandIdentifier = @"XYPartDeviceBrandIdentifier";
static NSString *const XYPartDeviceCellIdentifier = @"XYPartDeviceCellIdentifier";

@interface XYPartDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,XYPartFaultDelegate>
//UI
@property(strong,nonatomic) UITableView* brandsListView;
@property(strong,nonatomic) UITableView* tableView;
@property(strong,nonatomic) UISegmentedControl *segmentControl;
@property(strong,nonatomic) XYSelectDeviceViewModel* viewModel;
//result
@property(strong,nonatomic) XYPHPDeviceDto* selectedMould;
@end

@implementation XYPartDeviceViewController

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
    self.viewModel.brandId = nil;
}

- (void)initializeUIElements{
    self.navigationItem.title = @"选择机型";
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

#pragma mark - action

- (void)getDevices{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [self.viewModel getAllDevices:XYOrderDeviceTypeRepair success:^{
        [weakself hideLoadingMask];
        [weakself.brandsListView reloadData];
        [weakself.viewModel updateDevicesByBrandIndex:weakself.viewModel.currentBrandIndex andType:weakself.segmentControl.selectedSegmentIndex];
        [weakself.tableView reloadData];
    } errorString:^(NSString *e) {
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
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
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYPartDeviceBrandIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYPartDeviceBrandIdentifier];
            cell.textLabel.textColor = BLACK_COLOR;
            cell.textLabel.font = SIMPLE_TEXT_FONT;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        NSString* brandName = [self.viewModel.brandsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = brandName;
        cell.contentView.backgroundColor = (self.viewModel.currentBrandIndex == indexPath.row)?WHITE_COLOR:XY_HEX(0xf9f9f9);
        return cell;
    }else{
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYPartDeviceCellIdentifier];
        if (!cell){
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XYPartDeviceCellIdentifier];
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
        [self goToSelectFault:dto];
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

- (void)goToSelectFault:(XYPHPDeviceDto*)dto{
    XYPartFaultViewController* faultViewController = [[XYPartFaultViewController alloc]initWithDevice:dto.Id brand:dto.BrandId bid:dto.bid delegate:self];
    [self.navigationController pushViewController:faultViewController animated:true];
}

-(void)onPartsSelected:(XYPartsSelectionDto *)partsSelection {
    if ([self.delegate respondsToSelector:@selector(onPartsSelected:)]) {
        [self.delegate onPartsSelected:partsSelection];
    }
}

@end


