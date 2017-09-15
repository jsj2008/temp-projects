//
//  XYOrderListViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListViewController.h"
#import "XYOrderListViewModel.h"
#import "XYAddOrderViewController.h"
#import "XYAddPICCOrderViewController.h"
#import "XYOrderDetailViewController.h"
#import "XYOrderSearchViewController.h"
#import "XYClearDailyOrderViewController.h"
#import "XYCancelOrderViewController.h"
#import "XYCancelledOrdersViewController.h"
#import "HMSegmentedControl.h"
#import "XYOrderDaysTableView.h"
#import "XYCancelOrderTableView.h"
#import "PopoverView.h"
#import "XYPICCOrderDetailViewController.h"
#import "XYRecycleSelectDeviceViewController.h"
#import "XYRecycleOrderDetailViewController.h"
#import "XYAllOrdersTableView.h"
#import "XYCompleteOrderViewController.h"
#import "HttpCache.h"

@interface XYOrderListViewController ()<XYOrderListCallBackDelegate,XYTableViewWebDelegate,XYOrderListTableViewDelegate,UIAlertViewDelegate>
//UI
@property(strong,nonatomic)HMSegmentedControl* segmentControl;
@property(strong,nonatomic)UIScrollView* scrollView;
@property(strong,nonatomic)XYAllOrdersTableView* undoneOrdersListView;
@property(strong,nonatomic)XYCancelOrderTableView* cancelOrderListView;
@property(strong,nonatomic)XYOrderDaysTableView* clearedOrdersListView;
@property(strong,nonatomic)XYCompleteOrderViewController *completeOrderVc;

//navi item
@property(strong,nonatomic)UIBarButtonItem* searchItem;
@property(strong,nonatomic)UIBarButtonItem* uploadItem;
@property(strong,nonatomic)PopoverView* popOverView;
@property(strong,nonatomic)UIButton* rightBtn;
//VM
@property(strong,nonatomic)XYOrderListViewModel* viewModel;
@property(strong,nonatomic) NSArray* segTitleArray;


@end

@implementation XYOrderListViewController

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self doPreRefresh];
    
    //已完成
    
    __weak __typeof(&*self)weakSelf = self;
    XYCompleteOrderViewController *vc=  [[XYCompleteOrderViewController alloc] init];
    self.completeOrderVc = vc;
//    [self addChildViewController:self.completeOrderVc];
    [self.completeOrderVc setResetTitleCountBlock:^(NSInteger totalCount){
        [weakSelf reloadOrderCount:totalCount forIndex:XYOrderListSegmentTypeComplete];
    }];
    self.completeOrderVc.orderTableViewDelegate = self;
    self.completeOrderVc.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
    [self.scrollView addSubview:self.completeOrderVc.view];
    
    //    [self addChildViewController:self.completeOrderVc];

}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_LOGOUT object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //左侧：检查是否有未上传的照片
    if ([XYOrderListManager sharedInstance].photosReady && [[XYOrderListManager sharedInstance].cachedPhotosMap numberOfItemsInDic] > 0){
        self.navigationItem.leftBarButtonItems = @[self.searchItem,self.uploadItem];
    }else{
        self.navigationItem.leftBarButtonItems = @[self.searchItem];
    }

    //右侧：对魅族工程师隐藏添加订单按钮
    if (![[XYAPPSingleton sharedInstance] shouldBlockCreateOrderButton]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - override

- (void)initializeModelBinding{
    self.viewModel = [[XYOrderListViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)registerForNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewUserLogin) name:XY_NOTIFICATION_LOGIN object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserLogout) name:XY_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewOrder) name:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewOrder) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editNewOrder:) name:XY_NOTIFICATION_EDIT_REPAIR_NEW_ORDER object:nil];
}

- (void)initializeData{}

- (void)initializeUIElements{
    //导航栏
    self.navigationItem.title = @"我的订单";
    [self shouldShowBackButton:false];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchOrder)];
    //列表
    [self.view addSubview:self.segmentControl];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.undoneOrdersListView];
    [self.scrollView addSubview:self.cancelOrderListView];
    [self.scrollView addSubview:self.clearedOrdersListView];
    self.automaticallyAdjustsScrollViewInsets = false;
}

//-(XYCompleteOrderViewController *)completeOrderVc {
//    if (!_completeOrderVc) {
//        _completeOrderVc = [[XYCompleteOrderViewController alloc] init];
//        __weak __typeof(&*self)weakSelf = self;
//        [_completeOrderVc setResetTitleCountBlock:^(NSInteger totalCount){
//            [weakSelf reloadOrderCount:totalCount forIndex:XYOrderListSegmentTypeComplete];
//        }];
//        _completeOrderVc.orderTableViewDelegate = self;
//        
//        _completeOrderVc.view.frame = CGRectMake(2*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
//        [self.scrollView addSubview:_completeOrderVc.view];
//    }
//    return _completeOrderVc;
//}

- (void)doPreRefresh{
    if (![XYAPPSingleton sharedInstance].hasLogin) {
        return;
    }
    [self.undoneOrdersListView refresh];
    [self.cancelOrderListView updateCancelledOrders];
    [self.clearedOrdersListView refresh];
}


#pragma mark - property 

- (UIBarButtonItem*)searchItem{
    if (!_searchItem) {
        _searchItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchOrder)];
    }
    return _searchItem;
}

- (UIBarButtonItem*)uploadItem{
    if (!_uploadItem) {
        _uploadItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_upload"] style:UIBarButtonItemStylePlain target:self action:@selector(uploadCachedPhotos)];
    }
    return _uploadItem;
}

- (NSArray*)segTitleArray{
    if (!_segTitleArray) {
        _segTitleArray = @[@"未完成",@"取消订单",@"已完成",@"已结算"];
    }
    return _segTitleArray;
}

- (HMSegmentedControl*)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[HMSegmentedControl alloc]initWithSectionTitles:self.segTitleArray];
        _segmentControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
        _segmentControl.backgroundColor = WHITE_COLOR;
        _segmentControl.tintColor = THEME_COLOR;
        [_segmentControl addTarget:self action:@selector(onSegmentSelected:) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UIScrollView*)scrollView{
    if (!_scrollView) {
        CGFloat tabbarHeight = self.navigationController.tabBarController.tabBar.frame.size.height;
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, self.segmentControl.frame.origin.y + _segmentControl.frame.size.height, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - tabbarHeight - NAVI_BAR_HEIGHT - (self.segmentControl.frame.origin.y + self.segmentControl.frame.size.height))];
        _scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width * 4, _scrollView.frame.size.height);
        _scrollView.backgroundColor = BACKGROUND_COLOR;
        _scrollView.pagingEnabled = true;
        _scrollView.scrollEnabled = false;
    }
    return _scrollView;
}

- (XYAllOrdersTableView*)undoneOrdersListView{
    if (!_undoneOrdersListView) {
        _undoneOrdersListView = [[XYAllOrdersTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _undoneOrdersListView.type = XYAllOrderListViewTypeIncomplete;
        _undoneOrdersListView.backgroundColor = XY_COLOR(238,240,243);
        _undoneOrdersListView.webDelegate = self;
        _undoneOrdersListView.orderTableViewDelegate=self;
        _undoneOrdersListView.tag=0;
    }
    return _undoneOrdersListView;
}

- (XYCancelOrderTableView*)cancelOrderListView{
    if (!_cancelOrderListView) {
        _cancelOrderListView = [[XYCancelOrderTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _cancelOrderListView.backgroundColor = XY_COLOR(238,240,243);
        _cancelOrderListView.orderTableViewDelegate=self;
    }
    return _cancelOrderListView;
}

- (XYOrderDaysTableView*)clearedOrdersListView{
    if (!_clearedOrdersListView) {
        _clearedOrdersListView = [[XYOrderDaysTableView alloc]initWithFrame:CGRectMake(3*SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height)];
        _clearedOrdersListView.backgroundColor = XY_COLOR(238,240,243);
        _clearedOrdersListView.orderTableViewDelegate=self;
    }
    return _clearedOrdersListView;
}

- (UIButton*)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 17, 17)];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"order_add"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(addNewOrder) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightBtn;
}

- (PopoverView*)popOverView{
    if(!_popOverView){
        _popOverView = [[PopoverView alloc]init];
        _popOverView.menuTitles = @[@"添加维修订单", @"添加保险订单",@"添加回收订单"];
    }
    return _popOverView;
}

#pragma mark - action

//上传缓存照片
- (void)uploadCachedPhotos{
    self.uploadItem.enabled = false;
    [[XYOrderListManager sharedInstance] startUploadingAlbumImages];
}

/**
 *  搜索
 */
- (void)searchOrder{
    XYOrderSearchViewController* searchOrderViewController = [[XYOrderSearchViewController alloc]init];
    [self.navigationController pushViewController:searchOrderViewController animated:false];
}

/**
 *  添加新订单
 */
- (void)addNewOrder{
    __weak __typeof(&*self)weakSelf = self;
    [self.popOverView showFromView:self.rightBtn selected:^(NSInteger index) {
        if(index == 0){
            //普通订单
            XYAddOrderViewController* addOrderViewController = [[XYAddOrderViewController alloc]init];
            [weakSelf.navigationController pushViewController:addOrderViewController animated:true];
        }else if(index == 1){
            //保险订单
            XYAddPICCOrderViewController* addOrderViewController = [[XYAddPICCOrderViewController alloc]init];
            [weakSelf.navigationController pushViewController:addOrderViewController animated:true];
        }else if(index == 2){
            //回收订单
            XYRecycleSelectDeviceViewController* addOrderViewController = [[XYRecycleSelectDeviceViewController alloc]init];
            [weakSelf.navigationController pushViewController:addOrderViewController animated:true];
        }
    }];
}

#pragma mark - 外观

/**
 *  切换到未完成页面并刷新
 */
- (void)showNewOrdersList{
    [self.segmentControl setSelectedIndex:XYOrderListSegmentTypeIncomplete];
    self.scrollView.contentOffset = CGPointMake(self.segmentControl.selectedIndex * SCREEN_WIDTH,0);
    [self.undoneOrdersListView refresh];
}

/**
 *   切换列表视图
 */
- (void)onSegmentSelected:(id)sender{
    HMSegmentedControl* segControl = (HMSegmentedControl*)sender;
    //如果为加盟商工程师，禁止点击
    if ([XYAPPSingleton sharedInstance].currentUser.franchisee&&segControl.selectedIndex == XYOrderListSegmentTypeCleared) {
        return;
    }
    if (segControl.selectedIndex == XYOrderListSegmentTypeCancel) {//因为没有回调，取消订单每次都刷一下
        [self.cancelOrderListView updateCancelledOrders];
    }
    self.scrollView.contentOffset = CGPointMake(segControl.selectedIndex * SCREEN_WIDTH,0);
}

/**
 *   重置标题计数
 */
- (void)reloadOrderCount:(NSInteger)sum forIndex:(XYOrderListSegmentType)index{//纯显示概念
    [self.segmentControl setSectionTitle:[NSString stringWithFormat:@"%@(%@)",self.segTitleArray[index],@(sum)] forIndex:index];
}

#pragma mark - 订单相关跳转

- (void)cancelOrder:(NSString*)orderId bid:(XYBrandType)bid{
    XYCancelOrderViewController* cancelViewController = [[XYCancelOrderViewController alloc]init];
    cancelViewController.orderId = orderId;
    cancelViewController.bid = bid;
    [self.navigationController pushViewController:cancelViewController animated:true];
}

- (void)goToAllOrderDetail:(NSString *)orderId type:(XYAllOrderType)type bid:(XYBrandType)bid{
    switch (type) {
        case XYAllOrderTypeRepair:
            [self goToRepairOrderDetail:orderId bid:bid];
            break;
        case XYAllOrderTypeInsurance:
            [self goToPICCOrder:orderId];
            break;
        case XYAllOrderTypeRecycle:
            [self goToRecycleOrder:orderId];
            break;
        default:
            break;
    }
}
//维修订单详情
- (void)goToRepairOrderDetail:(NSString*)orderId bid:(XYBrandType)bid{
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}
//取消订单详情
- (void)goToCancelOrder:(NSString*)orderId bid:(XYBrandType)bid{
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}
//保险订单详情
- (void)goToPICCOrder:(NSString *)odd_number{
    XYPICCOrderDetailViewController* orderDetailViewController = [[XYPICCOrderDetailViewController alloc]init];
    orderDetailViewController.odd_number = odd_number;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}
//维修订单详情
- (void)goToRecycleOrder:(NSString *)orderId{
    XYRecycleOrderDetailViewController* orderDetailViewController = [[XYRecycleOrderDetailViewController alloc]init];
    orderDetailViewController.orderId = orderId;
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}
//结算折叠页面
- (void)goToClearFoldDay:(NSString*)dateStr{
    XYClearDailyOrderViewController* dailyOrderViewController =[[XYClearDailyOrderViewController alloc]init];
    dailyOrderViewController.titleStr=dateStr;
    [self.navigationController pushViewController:dailyOrderViewController animated:true];
}
//已取消订单
- (void)goToCancelDay:(NSString*)dateStr{
    XYCancelledOrdersViewController* cancelOrdersViewController = [[XYCancelledOrdersViewController alloc]init];
    cancelOrdersViewController.dateString = dateStr;
    [self.navigationController pushViewController:cancelOrdersViewController animated:true];
}

#pragma mark - 打电话

- (void)makePhoneCall:(NSString*)phone{
    if ([XYStringUtil isNullOrEmpty:phone]) {
        [self showToast:@"暂无用户联系方式"];
        return;
    }
    [XYAlertTool callPhone:phone onView:self];
    
}

#pragma mark - notification

- (void)onNewUserLogin{
    self.segmentControl.selectedIndex = 0;
    self.scrollView.contentOffset = CGPointZero;
    [self doPreRefresh];
}

- (void)onUserLogout{
    [[XYHttpClient sharedInstance]cancelAllRequests];
    [self.undoneOrdersListView resetAll];
    [self.clearedOrdersListView reset];
}

- (void)refreshNewOrder{
    [self refreshOrderList:true];
}

- (void)editNewOrder:(NSNotification*)notification{
    XYOrderBase* orderBase = notification.object;
    [self.undoneOrdersListView updateRepairOrder:orderBase];
}

#pragma mark - tableView

- (void)tableView:(XYBaseTableView *)tableView loadData:(NSInteger)p{
    if ([tableView isEqual:self.undoneOrdersListView]){
        [self.viewModel loadUndoneOrderLists:p];
    }
}

- (void)refreshOrderList:(BOOL)isNewOrder{
    if (isNewOrder) {
        [self.undoneOrdersListView refresh];
    }else{
        
    }
}

#pragma mark - call back
- (void)onDoneOrderListsLoaded:(BOOL)success orders:(NSArray *)ordersArray totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh noteString:(NSString *)noteString{
//    if (success) {
//        [self.completeOrdersListView addListItems:ordersArray isRefresh:isRefresh withTotalCount:totalCount];
//        [self reloadOrderCount:totalCount forIndex:XYOrderListSegmentTypeComplete];
//    }else{
//        [self showToast:noteString];
//        [self.completeOrdersListView onLoadingFailed];
//    }
}

- (void)onNewOrderListsLoaded:(BOOL)success orders:(NSArray *)ordersArray totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh noteString:(NSString *)noteString{
    if (success) {
        [self.undoneOrdersListView addListItems:ordersArray isRefresh:isRefresh withTotalCount:totalCount];
        [self reloadOrderCount:totalCount forIndex:XYOrderListSegmentTypeIncomplete];
    }else{
        [self showToast:noteString];
        [self.undoneOrdersListView onLoadingFailed];
    }
}

#pragma mark - 维修订单专属技能

- (void)onStatusOfOrder:(NSString*)orderId changedInto:(XYOrderStatus)status{
    [self hideLoadingMask];
    [self.viewModel loadUndoneOrderLists:1];
    if (status == XYOrderStatusDone || status == XYOrderStatusRepaired){
        [self.completeOrderVc loadData];
    }
}

- (void)onStatusOfOrder:(NSString *)orderId changingFailed:(NSString*)errorString{
    [self hideLoadingMask];
    [self showToast:errorString];
}

- (void)onOrderPaidByCash:(NSString *)orderId{
    [self hideLoadingMask];

    [self.completeOrderVc loadData];
}

- (void)changeStatusOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid{
    if(status == XYOrderStatusRepaired){
        //维修完成，直接去详情
        [self goToAllOrderDetail:orderId type:XYAllOrderTypeRepair bid:bid];
        return;
    }else if(status == XYOrderStatusCancelled){
        //取消订单，去取消页面
        [self cancelOrder:orderId bid:bid];
        return;
    }else if(status == XYOrderStatusShopRepairing){
        [XYAlertTool showConfirmCancelAlert:@"确定门店维修？" message:nil onView:self action:^{
            [self showLoadingMask];
            [self.viewModel turnStateOfOrder:orderId into:status bid:bid];
        } cancel:nil];
    }else if(status == XYOrderStatusOnTheWay){
        [XYAlertTool showConfirmCancelAlert:@"确定出发？" message:nil onView:self action:^{
            [self showLoadingMask];
            [self.viewModel turnStateOfOrder:orderId into:status bid:bid];
        } cancel:nil];
    }else{//普通转换
        [self showLoadingMask];
        [self.viewModel turnStateOfOrder:orderId into:status bid:bid];
    }
}

- (void)payByCashOfOrder:(NSString *)orderId bid:(XYBrandType)bid{
    [self showLoadingMask];
    [self.viewModel payOrderByCash:orderId bid:bid];
}

- (void)payByWorker:(NSString *)orderId bid:(XYBrandType)bid{
    //展示支付方式选项
    XYOrderDetailViewController* orderDetailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
    [self.navigationController pushViewController:orderDetailViewController animated:true];
}

@end
