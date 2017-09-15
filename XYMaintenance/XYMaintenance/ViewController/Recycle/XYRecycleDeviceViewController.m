//
//  XYRecycleDeviceViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleDeviceViewController.h"
#import "XYRecycleEvaluationViewController.h"
#import "XYAPIService+V6API.h"

static NSString *const XYRecycleDeviceHeaderIdentifier = @"XYRecycleDeviceHeaderIdentifier";
static NSString *const XYRecycleDeviceCellIdentifier = @"XYRecycleDeviceCellIdentifier";

@interface XYRecycleDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)NSArray* titleArray;
@property(strong,nonatomic)NSArray* sectionTitlesArray;
@property(strong,nonatomic)NSArray* sectionIndexesArray;
@property(strong,nonatomic)NSDictionary *deviceMap;
@end

@implementation XYRecycleDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override

- (void)initializeUIElements{
    self.navigationItem.title = @"选择回收机型";
    [self shouldShowBackButton:true];
    [self.view addSubview:self.tableView];
}

#pragma mark - property

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenFrameHeight - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = WHITE_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [_tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
    }
    return _tableView;
}

- (void)getDevices{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getRecycleDevicesList:^(NSDictionary *deviceDic) {
        [weakself hideLoadingMask];
        weakself.deviceMap = deviceDic;
        weakself.titleArray = [self sortedKeyArray];
        [weakself generateSectionIndexs];
        [weakself.tableView reloadData];
    } errorString:^(NSString *e) {
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
}

#pragma mark - tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.deviceMap objectForKey:[self.titleArray objectAtIndex:section]]count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYRecycleDeviceCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:XYRecycleDeviceCellIdentifier];
        cell.textLabel.textColor = BLACK_COLOR;
        cell.textLabel.font = LARGE_TEXT_FONT;
        cell.detailTextLabel.textColor = LIGHT_TEXT_COLOR;
        cell.detailTextLabel.font = SMALL_TEXT_FONT;
    }
    
    XYRecycleDeviceDto* dto = [[self.deviceMap objectForKey:[self.titleArray objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@" %@",dto.MouldName];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"均价：￥%@",@(dto.avg_price)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:XYRecycleDeviceHeaderIdentifier];
    if (!headerView) {
        headerView = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:XYRecycleDeviceHeaderIdentifier];
        headerView.contentView.backgroundColor = XY_COLOR(236, 240, 246);
        headerView.textLabel.font = SIMPLE_TEXT_FONT;
        headerView.textLabel.textColor = BLACK_COLOR;
    }
    headerView.textLabel.text = [self.titleArray objectAtIndex:section];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [[self.sectionIndexesArray objectAtIndex:index] integerValue];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.sectionTitlesArray;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYRecycleDeviceDto* dto = [[self.deviceMap objectForKey:[self.titleArray objectAtIndex:indexPath.section]]objectAtIndex:indexPath.row];
    if (self.delegate) {
       [self.delegate onDeviceSelected:dto];
    }else{
       [self goToEvaluationWithDevice:dto];
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


#pragma mark - action

- (void)goToEvaluationWithDevice:(XYRecycleDeviceDto*)dto{
    XYRecycleEvaluationViewController* evaluationController = [[XYRecycleEvaluationViewController alloc]init];
    evaluationController.preOrderDetail = [self createOrderWithDevice:dto];
    [self.navigationController pushViewController:evaluationController animated:true];
}

- (XYRecycleOrderDetail*)createOrderWithDevice:(XYRecycleDeviceDto*)dto{
    XYRecycleOrderDetail* orderDetail = [[XYRecycleOrderDetail alloc]init];
    orderDetail.mould_id = dto.Id;
    orderDetail.mould_name = dto.MouldName;
    return orderDetail;
}

#pragma mark - dirty

- (void)generateSectionIndexs{
    
    NSMutableArray* secMutableArray = [[NSMutableArray alloc]init];
    NSMutableArray* secIndexMutableArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < [self.titleArray count]; i++){
        NSString* str = [self.titleArray objectAtIndex:i];
        for (NSInteger j = 0; j < [str length]; j ++) {
            [secMutableArray addObject:[NSString stringWithFormat:@"  %@  ",[str substringWithRange:NSMakeRange(j, 1)]]];
            [secIndexMutableArray addObject:@(i)];
        }
        for (NSInteger k = 0; k < 3; k ++){
            [secMutableArray addObject:@""];
            [secIndexMutableArray addObject:@(-1)];
        }
    }
    self.sectionTitlesArray = secMutableArray;
    self.sectionIndexesArray = secIndexMutableArray;
}

- (NSArray*)sortedKeyArray{
    return [[self.deviceMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        if([key1 rangeOfString:@"苹果"].length > 0){
            return NSOrderedAscending;
        }else if([key2 rangeOfString:@"苹果"].length > 0){
            return NSOrderedDescending;
        }else{
            return [key1 compare:key2];
        }
    }];
}

@end
