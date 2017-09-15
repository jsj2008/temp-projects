//
//  XYBonusListViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBonusListViewController.h"
#import "XYBonusCell.h"
#import "PopoverView.h"
#import "XYOrderDetailViewController.h"
#import "XYPICCOrderDetailViewController.h"
#import "XYRecycleOrderDetailViewController.h"

@interface XYBonusListViewController ()<UITableViewDataSource,UITableViewDelegate,XYTableViewWebDelegate>
@property(assign,nonatomic)XYBonusListType type;
@property(assign,nonatomic)XYBonusListCategory category;
@property(strong,nonatomic)NSArray* titleArray;
@property(strong,nonatomic)UIButton* titleButton;
@property(strong,nonatomic)PopoverView* popOverView;
@property(strong,nonatomic)XYBaseTableView* tableView;
@end

@implementation XYBonusListViewController

- (instancetype)initWithType:(XYBonusListType)type{
    if (self = [super init]) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadBonusView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

- (void)initializeData{
    //默认值
    if (self.type == XYBonusListTypeUnknown) {
        self.type = XYBonusListTypeToday;//默认今日
    }
    if (self.category == XYBonusListCategoryUnkown){
        self.category = XYBonusListCategoryRepair;//默认维修
    }
    //设置选项
    self.titleArray = [self getTitleArray];
}

- (void)initializeUIElements{
    self.navigationItem.titleView = self.titleButton;
    [self.view addSubview:self.tableView];
}

#pragma mark - property

- (NSArray*)getTitleArray{
    NSMutableArray* titleArray = [[NSMutableArray alloc]init];
    [titleArray addObject:[NSString stringWithFormat:@"%@%@",[self getTypeStrByEnum:self.type],[self getCategoryStrByEnum:XYBonusListCategoryRepair]]];
    [titleArray addObject:[NSString stringWithFormat:@"%@%@",[self getTypeStrByEnum:self.type],[self getCategoryStrByEnum:XYBonusListCategoryInsurance]]];
    [titleArray addObject:[NSString stringWithFormat:@"%@%@",[self getTypeStrByEnum:self.type],[self getCategoryStrByEnum:XYBonusListCategoryRecycle]]];
    return titleArray;
}


- (UIButton*)titleButton{
    if (!_titleButton) {
        if (SCREEN_WIDTH > 350) {
            _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 30)];
        }else{
            _titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*2/3.0, 30)];
        }
        _titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0];
        [_titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_titleButton addTarget:self action:@selector(titleButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        UIImage* image = [UIImage imageNamed:@"arrow_down_white"];
        [_titleButton setImage:image forState:UIControlStateNormal];
        _titleButton.titleLabel.adjustsFontSizeToFitWidth = true;
        ;
    }
    return _titleButton;
}

- (XYBaseTableView*)tableView{
    if (!_tableView) {
        _tableView = [[XYBaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT)];
        _tableView.backgroundColor = XY_COLOR(238,240,243);
        _tableView.separatorColor = TABLE_DEVIDER_COLOR;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.webDelegate = self;
        [_tableView setTableHeaderView:nil];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLineWithInset:15]];
        [XYBonusCell xy_registerTableView:_tableView identifier:[XYBonusCell defaultIdentifier]];
    }
    return _tableView;
}

- (PopoverView*)popOverView{
    if(!_popOverView){
        _popOverView = [[PopoverView alloc]init];
        _popOverView.menuTitles = self.titleArray;
    }
    return _popOverView;
}

#pragma mark - title

- (NSString*)getTypeStrByEnum:(XYBonusListType)eType{
    switch (eType) {
        case XYBonusListTypeToday:
            return @"今日提成";
        case XYBonusListTypeMonth:
            return @"本月提成";
        case XYBonusListTypeTotal:
            return @"历史提成";
        default:
            return @"";
    }
}

- (NSString*)getCategoryStrByEnum:(XYBonusListCategory)eCategory{
    switch (eCategory) {
        case XYBonusListCategoryRepair:
            return @"（维修订单）";
        case XYBonusListCategoryInsurance:
            return @"（保险订单）";
        case XYBonusListCategoryRecycle:
            return @"（回收订单）";
        default:
            return @"";
    }
}


#pragma mark - action

- (void)titleButtonClicked:(id)sender{
    [self.popOverView showFromView:self.titleButton selected:^(NSInteger index) {
        self.category = (XYBonusListCategory)index;
        [self reloadBonusView];
    }];
}

- (void)reloadBonusView{
    [self.titleButton setTitle:[NSString stringWithFormat:@"%@%@",[self getTypeStrByEnum:self.type],[self getCategoryStrByEnum:self.category]] forState:UIControlStateNormal];
    [self.titleButton sizeToFit];
    [self.titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 18)];
    if (SCREEN_WIDTH > 350) {
       [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH/2 - 17, 0, 0)];
    }else{
       [self.titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, SCREEN_WIDTH*2/3.0 - 17, 0, 0)];
    }
    [self showLoadingMask];
    [self.tableView refresh];
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableView.dataList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    XYBonusCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYBonusCell defaultIdentifier]];
    
    id dto = [self.tableView.dataList objectAtIndex:indexPath.row];
    if ([dto isKindOfClass:[XYBonusDetailDto class]]) {
        [cell setRepairBonusData:(XYBonusDetailDto*)dto];
    }else if ([dto isKindOfClass:[XYPICCBonusDto class]]) {
        [cell setPICCBonusData:(XYPICCBonusDto*)dto];
    }else if ([dto isKindOfClass:[XYRecycleBonusDto class]]){
       [cell setRecycleBonusData:(XYRecycleBonusDto*)dto];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYBonusCell getHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYBonusDetailDto* dto = [self.tableView.dataList objectAtIndex:indexPath.row];
    
    if ([dto isKindOfClass:[XYBonusDetailDto class]]) {
        XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:((XYBonusDetailDto*)dto).id brand:((XYBonusDetailDto*)dto).bid];
        [self.navigationController pushViewController:orderDetailViewController animated:true];
    }else if ([dto isKindOfClass:[XYPICCBonusDto class]]) {
        XYPICCOrderDetailViewController* orderDetailViewController = [[XYPICCOrderDetailViewController alloc]init];
        orderDetailViewController.odd_number = ((XYPICCBonusDto*)dto).odd_number;
        [self.navigationController pushViewController:orderDetailViewController animated:true];
    }else if ([dto isKindOfClass:[XYRecycleBonusDto class]]) {
        XYRecycleOrderDetailViewController* orderDetailViewController = [[XYRecycleOrderDetailViewController alloc]init];
        orderDetailViewController.orderId = ((XYPICCBonusDto*)dto).id;
        [self.navigationController pushViewController:orderDetailViewController animated:true];
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

- (void)tableView:(XYBaseTableView *)tableView loadData:(NSInteger)p{
    switch (self.category) {
        case XYBonusListCategoryRepair:
            [self getRepairDataOfPage:p];
            break;
        case XYBonusListCategoryInsurance:
            [self getInsuranceDataOfPage:p];
            break;
        case XYBonusListCategoryRecycle:
            [self getRecycleDataOfPage:p];
            break;
        default:
            break;
    }
    
}


- (void)getRepairDataOfPage:(NSInteger)page{
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]getRepairBonusList:self.type page:page success:^(NSArray *orderList, NSInteger sum) {
        [weakSelf hideLoadingMask];
        [weakSelf.tableView addListItems:orderList isRefresh:(page==1) withTotalCount:sum];
    } errorString:^(NSString *error) {
        [weakSelf.tableView onLoadingFailed];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (void)getInsuranceDataOfPage:(NSInteger)page{
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]getInsuranceBonusList:self.type page:page success:^(NSArray *orderList, NSInteger sum) {
        [weakSelf hideLoadingMask];
        [weakSelf.tableView addListItems:orderList isRefresh:(page==1) withTotalCount:sum];
    } errorString:^(NSString *error) {
        [weakSelf.tableView onLoadingFailed];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
}

- (void)getRecycleDataOfPage:(NSInteger)page{
    __weak __typeof(self)weakSelf = self;
    [[XYAPIService shareInstance]getRecycleBonusList:self.type page:page success:^(NSArray *orderList, NSInteger sum) {
        [weakSelf hideLoadingMask];
        [weakSelf.tableView addListItems:orderList isRefresh:(page==1) withTotalCount:sum];
    } errorString:^(NSString *error) {
        [weakSelf.tableView onLoadingFailed];
        [weakSelf hideLoadingMask];
        [weakSelf showToast:error];
    }];
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
