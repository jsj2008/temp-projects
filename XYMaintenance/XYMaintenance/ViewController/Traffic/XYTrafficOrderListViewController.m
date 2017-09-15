//
//  XYTrafficOrderListViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficOrderListViewController.h"
#import "XYTrafficSelectMapViewController.h"
#import "XYTrafficSearchTipViewController.h"
#import "XYDailyOrderCell.h"
#import "XYAPIService.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>


@interface XYTrafficOrderListViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,XYTrafficMapLocationDelegate,AMapSearchDelegate,XYTrafficSearchTipDelegate>

@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)UISearchBar* searchBar;
@property(strong,nonatomic)UITableView* tipsView;

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) NSArray* orderLocsArray;

@end

@implementation XYTrafficOrderListViewController

-(id)initWithRouteId:(NSInteger)section startOrEnd:(BOOL)isStart
{
    if (self = [super init]) {
        _routeId = section;
        _isStartLoc = isStart;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        [self loadOrderList];
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.search) {
        self.search.delegate = self;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - override

-(void)initializeUIElements{
    
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    self.search.delegate = self;
    
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 40, 30)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate= self;
    self.searchBar.placeholder  = @"请输入地铁站/小区/商圈等";
    [self shouldShowBackButton:true];
     
    UIButton* companyButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/2, 50)];
    [companyButton setImage:[UIImage imageNamed:@"tfc_my_company"] forState:UIControlStateNormal];
    companyButton.backgroundColor = WHITE_COLOR;
    [companyButton addTarget:self action:@selector(selectMyCompany) forControlEvents:UIControlEventTouchUpInside];
    [companyButton setTitle:@"   我的公司" forState:UIControlStateNormal];
    companyButton.titleLabel.font = SIMPLE_TEXT_FONT;
    [companyButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [self.view addSubview:companyButton];
    
    UIView* deviderLine = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2, 0, LINE_HEIGHT, 50)];
    deviderLine.backgroundColor = XY_COLOR(210,218,228);
    [self.view addSubview:deviderLine];
    
    UIButton* mapButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2+LINE_HEIGHT, 0, ScreenWidth/2, 50)];
    mapButton.backgroundColor = WHITE_COLOR;
    [mapButton setImage:[UIImage imageNamed:@"tfc_map_loc"] forState:UIControlStateNormal];
    [mapButton setTitle:@"   地图选点" forState:UIControlStateNormal];
     mapButton.titleLabel.font = SIMPLE_TEXT_FONT;
     [mapButton setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(goToSelectMap) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapButton];
    
    UIView* bottomLine = [[UIView alloc]initWithFrame:CGRectMake(0, mapButton.frame.origin.y + mapButton.frame.size.height, ScreenWidth, LINE_HEIGHT)];
    bottomLine.backgroundColor = XY_COLOR(210,218,228);
    [self.view addSubview:bottomLine];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, mapButton.frame.origin.y + mapButton.frame.size.height + 10, ScreenWidth, ScreenFrameHeight - NAVI_BAR_HEIGHT - mapButton.frame.size.height - 10)];
    self.tableView.backgroundColor = BACKGROUND_COLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    self.tableView.separatorColor = XY_COLOR(210,218,228);
    [self.tableView setTableHeaderView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.view addSubview:self.tableView];

}

#pragma mark - property

- (NSArray*)orderLocsArray{
    if (!_orderLocsArray) {
        _orderLocsArray = [[NSArray alloc]init];
    }
    return _orderLocsArray;
}

- (AMapSearchAPI*)search{
    if (!_search) {
        [MAMapServices sharedServices].apiKey = GAODE_KEY;
        _search = [[AMapSearchAPI alloc]init];
    }
    return _search;
}


#pragma mark - searchbar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self goToSearchTips];
    return false;
}

#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.orderLocsArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYDailyOrderCell defaultHeight];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYDailyOrderCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYDailyOrderCell defaultReuseId]];
    if (!cell) {
         cell = [[[NSBundle mainBundle]loadNibNamed:[XYDailyOrderCell defaultReuseId] owner:self options:nil]lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.selectButton addTarget:self action:@selector(selectOrderLoc:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell setData:[self.orderLocsArray objectAtIndex:indexPath.row]];
     cell.selectButton.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - action

//获取订单列表
- (void)loadOrderList{
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getDailyCompletedOrders:self.date success:^(NSArray *ordersArray) {
        [weakself hideLoadingMask];
        _orderLocsArray = ordersArray?ordersArray:[[NSArray alloc]init];
        [_tableView reloadData];
    } errorString:^(NSString *error) {
        [weakself hideLoadingMask];
        [weakself showToast:error];
    }];
}

-(void)goToSearchTips{
    XYTrafficSearchTipViewController* searchTipViewController = [[XYTrafficSearchTipViewController alloc]init];
    searchTipViewController.delegate = self;
    searchTipViewController.search = self.search;
    [self.navigationController pushViewController:searchTipViewController animated:false];
}

-(void)selectMyCompany{
    [self.view endEditing:false];
    [self.delegate onLocationStrSelected:@"公司" routeIndex:self.routeId startOrEnd:self.isStartLoc];
}

-(void)goToSelectMap{
    [self.view endEditing:false];
    XYTrafficSelectMapViewController* selectMapViewController = [[XYTrafficSelectMapViewController alloc]init];
    selectMapViewController.search = self.search;
    selectMapViewController.locDelegate = self;
    [self.navigationController pushViewController:selectMapViewController animated:true];
}

-(void)selectOrderLoc:(UIButton*)btn{
    [self.view endEditing:false];
    XYTrafficOrderLocDto* orderLoc = [self.orderLocsArray objectAtIndex:btn.tag];
    [self.delegate onLocationStrSelected:orderLoc.address routeIndex:self.routeId startOrEnd:self.isStartLoc];
}

#pragma mark - select loc

-(void)onTrafficLocationSelected:(NSString *)locString{
    [self.delegate onLocationStrSelected:locString routeIndex:self.routeId startOrEnd:self.isStartLoc];
}

-(void)onLocationTipSelected:(NSString *)locName{
    [self.delegate onLocationStrSelected:locName routeIndex:self.routeId startOrEnd:self.isStartLoc];
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
