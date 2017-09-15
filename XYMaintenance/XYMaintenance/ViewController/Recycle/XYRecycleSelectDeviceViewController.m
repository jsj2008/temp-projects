//
//  XYRecycleSelectDeviceViewController.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/25.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleSelectDeviceViewController.h"
#import "MultilevelCollectionViewCell.h"
#import "XYRecycleEvaluationViewController.h"

static NSString *const XYRecycleDeviceCellIdentifier = @"XYRecycleDeviceCellIdentifier";


typedef NS_ENUM(NSUInteger, XYRecycleDeviceType) {
    XYRecycleDeviceTypeUnknown = -1, //
    XYRecycleDeviceTypePhone = 0, //手机
    XYRecycleDeviceTypePad = 1    //平板
};

@interface XYRecycleSelectDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong,nonatomic) NSDictionary* deviceMap;
@property (strong,nonatomic) NSArray* brandsArray;
@property (strong,nonatomic) NSMutableArray* itemsArray;
@property (assign,nonatomic) NSInteger currentBrandIndex;
@end

@implementation XYRecycleSelectDeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getDevices];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeData{
    self.currentBrandIndex = 0;
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"选择回收机型";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = XY_HEX(0xededed);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.bounces = false;
    [self.tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_HEX(0xededed)]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing=0.f;//左右间隔
    flowLayout.minimumLineSpacing=0.f;
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.backgroundColor = WHITE_COLOR;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:[MultilevelCollectionViewCell defaultReuseId] bundle:nil] forCellWithReuseIdentifier:[MultilevelCollectionViewCell defaultReuseId]];
    
    self.segmentControl.tintColor = THEME_COLOR;
    [self.segmentControl addTarget:self action:@selector(onSegSelected:) forControlEvents:UIControlEventValueChanged];
}

#pragma mark - property

- (NSArray*)brandsArray{
    if (!_brandsArray) {
        _brandsArray = [[NSArray alloc]init];
    }
    return _brandsArray;
}

- (NSMutableArray*)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc]init];
    }
    return _itemsArray;
}

#pragma mark - seg

- (void)onSegSelected:(UISegmentedControl*)seg{
    switch (seg.selectedSegmentIndex) {
        case XYRecycleDeviceTypePhone:
        case XYRecycleDeviceTypePad:
            [self updateDevicesByBrandIndex:self.currentBrandIndex andType:seg.selectedSegmentIndex];
            break;
        default:
            break;
    }
}

#pragma mark - tableView 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.brandsArray count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:XYRecycleDeviceCellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:XYRecycleDeviceCellIdentifier];
        cell.textLabel.textColor = BLACK_COLOR;
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    NSString* brandName = [self.brandsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = brandName;
    cell.contentView.backgroundColor = (self.currentBrandIndex == indexPath.row)?WHITE_COLOR:XY_HEX(0xf9f9f9);
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    self.currentBrandIndex = indexPath.row;
    [self.tableView reloadData];
    [self updateDevicesByBrandIndex:self.currentBrandIndex andType:self.segmentControl.selectedSegmentIndex];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - collectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0,0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    XYRecycleDeviceDto* dto = [self.itemsArray objectAtIndex:indexPath.row];
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(onDeviceSelected:)]) {
            [self.delegate onDeviceSelected:dto];
        }
    }else{
        [self goToEvaluationWithDevice:dto];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 90)/2, 157.5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MultilevelCollectionViewCell *cell= [self.collectionView dequeueReusableCellWithReuseIdentifier:[MultilevelCollectionViewCell defaultReuseId] forIndexPath:indexPath];
    cell.leftLineView.hidden = (indexPath.row % 2 == 0);
    XYRecycleDeviceDto* dto = [self.itemsArray objectAtIndex:indexPath.row];
    [cell setData:dto];
    return cell;
}

#pragma mark - logic

- (void)getDevices{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance] getRecycleDevicesList:^(NSDictionary *deviceDic) {
        [weakself hideLoadingMask];
        weakself.deviceMap = deviceDic;
        [weakself onDevicesLoaded];
    } errorString:^(NSString *e) {
        [weakself hideLoadingMask];
        [weakself showToast:e];
    }];
}

- (void)onDevicesLoaded{
    //生成品牌名列表
    NSMutableDictionary* brandsMap = [[NSMutableDictionary alloc]init];
    for (NSString* key in [self.deviceMap allKeys]) {
        NSArray* array = self.deviceMap[key];
        if ((!array)||array.count > 0) {
            XYRecycleDeviceDto* dto = array[0];
            [brandsMap setValue:dto.BrandId forKey:dto.BrandName];
        }
    }
    self.brandsArray = [[brandsMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [brandsMap[obj1] compare:brandsMap[obj2]];
    }];
    [self.tableView reloadData];
    [self updateDevicesByBrandIndex:self.currentBrandIndex andType:self.segmentControl.selectedSegmentIndex];
}

- (XYRecycleDeviceType)getTypeByProductName:(NSString*)proName{
    if ([proName isEqualToString:@"手机"]) {
        return XYRecycleDeviceTypePhone;
    }else if ([proName isEqualToString:@"平板"]) {
        return XYRecycleDeviceTypePad;
    }
    return XYRecycleDeviceTypeUnknown;
}

- (void)updateDevicesByBrandIndex:(NSInteger)brandIndex andType:(XYRecycleDeviceType)type{
    [self.itemsArray removeAllObjects];
    if (brandIndex >= 0 && brandIndex < self.brandsArray.count) {
        NSString* brandName = self.brandsArray[brandIndex];
        for (NSString* key in [self.deviceMap allKeys]) {
            NSArray* array = self.deviceMap[key];
            for (XYRecycleDeviceDto* dto in array) {
                if ([dto.BrandName isEqualToString:brandName] &&
                    ([self getTypeByProductName:dto.ProductName] == type)) {
                    [self.itemsArray addObject:dto];
                }
            }
        }
    }
    [self.collectionView reloadData];
    return;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
