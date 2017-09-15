//
//  XYOrderListMapViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListMapViewController.h"
#import "XYNewOrderListMapCell.h"
#import "XYPoolOrderListMapCell.h"
#import "XYOrderListAnnotation.h"
#import "XYOrderListManager.h"
#import "AMapXYUtility.h"
#import "XYOrderSearchViewController.h"
#import "XYAddOrderViewController.h"
#import "XYOrderDetailViewController.h"
#import "AppDelegate.h"
#import "XYRootViewController.h"
#import "XYPushDto.h"
#import "XYDtoTransferer.h"

typedef NS_ENUM(NSInteger, XYOrderListMapType) {
    XYOrderListMapTypeTodayAssign = 0,
    XYOrderListMapTypePoolOrder = 1,
    XYOrderListMapTypeOverTime = 2,
};


@interface XYOrderListMapViewController ()<MAMapViewDelegate,UITableViewDataSource,UITableViewDelegate,XYNewOrderListMapCellDelegate,XYPoolOrderListMapCellDelegate>
//UI
@property (strong,nonatomic) MAMapView* aMapView;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) XYOrderListAnnotationView *lastAnnotationView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *locButton;
@property (weak, nonatomic) IBOutlet UIButton *todayOrdersButton;
@property (weak, nonatomic) IBOutlet UIButton *assignOrdersButton;
@property (weak, nonatomic) IBOutlet UIButton *overtimeOrdersButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *panelHeight;//详情面板的显示隐藏
@property (strong,nonatomic) UIBarButtonItem* refreshButtonItem;
//data
@property (assign,nonatomic) XYOrderListMapType currentMapType;//当前显示地图类型
@property (copy,nonatomic) NSString* lastSelectedOrder;
@property (strong,nonatomic) NSMutableArray* incompleteOrdersArray;
@property (strong,nonatomic) NSMutableArray* poolOrdersArray;
@property (strong,nonatomic) NSMutableArray* overTimeOrdersArray;
@end

@implementation XYOrderListMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:XY_NOTIFICATION_REFRESH_NEW_ORDER_MAP object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.aMapView.showsUserLocation = true;
    self.aMapView.delegate = self;
    //如果是从子页面返回，不做任何刷新操作、节约流量
    if (!self.isFromTabSelection) {
        [self reloadOrderList];
        return;
    }
    self.isFromTabSelection = false;
    //否则
    [self refreshMapList];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.containerView insertSubview:self.aMapView atIndex:0];
    [self.aMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.containerView);
    }];
    self.aMapView.showsUserLocation = true;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.aMapView.showsUserLocation = false;
    self.aMapView.delegate = nil;
}

#pragma mark - override
- (void)registerForNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNewOrderPool) name:XY_NOTIFICATION_REFRESH_NEW_ORDER_MAP object:nil];
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"订单地图";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"order_search"] style:UIBarButtonItemStylePlain target:self action:@selector(searchOrder)];
    //map
    [self.containerView insertSubview:self.aMapView atIndex:0];
    [self.aMapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.containerView);
    }];
    //button
    self.locButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    self.locButton.layer.cornerRadius = 5.0f;
    self.locButton.layer.masksToBounds = true;
    self.todayOrdersButton.titleLabel.numberOfLines = 2;
    self.assignOrdersButton.titleLabel.numberOfLines = 2;
    self.overtimeOrdersButton.titleLabel.numberOfLines = 2;
    self.currentMapType = XYOrderListMapTypeTodayAssign;//初始展示今日预约
    //tableView
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [XYNewOrderListMapCell xy_registerTableView:self.tableView identifier:[XYNewOrderListMapCell defaultReuseId]];
    [XYPoolOrderListMapCell xy_registerTableView:self.tableView identifier:[XYPoolOrderListMapCell defaultReuseId]];
    //起初隐藏信息面板
    self.panelHeight.constant = 0;
}

#pragma mark - property

- (UIBarButtonItem*)refreshButtonItem{
    if (!_refreshButtonItem) {
         _refreshButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshOrderPool)];
    }
    return _refreshButtonItem;
}

- (void)setCurrentMapType:(XYOrderListMapType)type{
    //切换
    _currentMapType = type;
    switch (type) {
        case XYOrderListMapTypeTodayAssign:
            [self.todayOrdersButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            [self.assignOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            [self.overtimeOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            self.tableView.rowHeight = [XYNewOrderListMapCell getHeight];
            break;
        case XYOrderListMapTypePoolOrder:
            [self.todayOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            [self.assignOrdersButton setTitleColor:REVERSE_COLOR forState:UIControlStateNormal];
            [self.overtimeOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            self.tableView.rowHeight = [XYPoolOrderListMapCell getHeight];
            break;
        case XYOrderListMapTypeOverTime:
            [self.todayOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            [self.assignOrdersButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
            [self.overtimeOrdersButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
            self.tableView.rowHeight = [XYPoolOrderListMapCell getHeight];
            break;
        default:
            break;
    }
}

- (MAMapView*)aMapView{
    if (!_aMapView) {
        _aMapView = [[MAMapView alloc]init];
        [_aMapView setZoomLevel:_aMapView.maxZoomLevel - 5];
        _aMapView.delegate = self;
        _aMapView.showsUserLocation = true;
        _aMapView.showsCompass = NO;
        _aMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
    }
    return _aMapView;
}


#pragma mark - action

- (IBAction)focusOnMyLocation:(id)sender {
    //窗口移动到本人位置
    [self.aMapView setCenterCoordinate:self.aMapView.userLocation.coordinate];
}

- (void)reloadOrderList{
    //刷新详情显示
    [self updateCurrentOrderDetail];
    //刷新地图显示
    [self clearMapView];
    [self addOrderAnnotations:self.currentMapType];
}

- (void)updateCurrentOrderDetail{
    //展示选中点详情
    if (!self.lastSelectedOrder){
        self.panelHeight.constant = 0;
        return;
    }
    self.panelHeight.constant = self.tableView.rowHeight;
    [self.tableView reloadData];
}

- (void)addOrderAnnotations:(XYOrderListMapType)type{
    
    switch (type) {
        case XYOrderListMapTypeTodayAssign:
            for (XYOrderBase* order in self.incompleteOrdersArray) {
                [self addAnnotationByOrder:order];//添加接单地图标注点
            }
            break;
        case XYOrderListMapTypePoolOrder:
            for (XYOrderBase* order in self.poolOrdersArray) {
                [self addAnnotationByOrder:order];//添加接单地图标注点
            }
            break;
        case XYOrderListMapTypeOverTime:
            for (XYOrderBase* order in self.overTimeOrdersArray) {
                [self addAnnotationByOrder:order];//添加接单地图标注点
            }
            break;
        default:
            break;
    }
    [self updateMapVisibleView];
}

- (void)clearMapView{
    //清空地图标注
    for (id<MAAnnotation> anno in self.aMapView.annotations) {
        if ([anno isKindOfClass:[XYOrderMapAnnotation class]]) {
            [self.aMapView removeAnnotation:anno];
        }
    }
    [self.aMapView removeOverlays:self.aMapView.overlays];
    self.aMapView.showsUserLocation = true;
}

- (void)addAnnotationByOrder:(XYOrderBase*)order{
    //为订单添加标注
    if (!order) {
        return;
    }
    CGFloat lat = [order.lat doubleValue];
    CGFloat lng = [order.lng doubleValue];
    if (lat < 0.5 && lng < 0.5) {
        return;//(0,0)坐标直接pass
    }
    XYOrderMapAnnotation *orderAnnotation = [[XYOrderMapAnnotation alloc]init];
#warning 改不改
    orderAnnotation.timeString = [[NSDate dateWithTimeIntervalSince1970:[order.reserveTime doubleValue]] formattedDateWithFormat:@"HH:mm"];
    orderAnnotation.orderId = XY_NOTNULL(order.id, @"") ;
    orderAnnotation.bid = order.bid;
    orderAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lng);
    orderAnnotation.orderLevel = 0;
    [self updateAnnotationLevel:orderAnnotation];//更新现有地图标注点的层级
    [self.aMapView addAnnotation:orderAnnotation];
}

- (void)updateAnnotationLevel:(XYOrderMapAnnotation*)annotation{
    for (id<MAAnnotation> anno in self.aMapView.annotations) {
        if ([anno isKindOfClass:[XYOrderMapAnnotation class]]) {
            if (anno.coordinate.latitude == annotation.coordinate.latitude && anno.coordinate.longitude == annotation.coordinate.longitude) {
                ((XYOrderMapAnnotation*)annotation).orderLevel ++;
            }
        }
    }
}

- (void)updateMapVisibleView{
    //窗口展示范围逻辑
    if(self.aMapView.annotations.count > 1){//多订单
        [self.aMapView setVisibleMapRect:[CommonUtility minMapRectForAnnotations:self.aMapView.annotations] animated:YES];
    }else if(self.aMapView.annotations.count > 0){//单订单
        id<MAAnnotation> userAnnotation = self.aMapView.annotations[0];
        [self.aMapView setCenterCoordinate:userAnnotation.coordinate];
    }else{//无订单
        [self.aMapView setCenterCoordinate:self.aMapView.userLocation.coordinate];
    }
}

#pragma mark - collection View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (self.currentMapType) {
        case XYOrderListMapTypeTodayAssign:
        {
            //今日预约
            XYNewOrderListMapCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYNewOrderListMapCell defaultReuseId]];
            cell.delegate = self;
            for (XYOrderBase* order in self.incompleteOrdersArray){
                if ([order.id isEqualToString:self.lastSelectedOrder]) {
                    [cell setData:order];
                    break;
                }
            }
            return cell;
        }
            break;
        case XYOrderListMapTypePoolOrder:
        {
            //接单地图
            XYPoolOrderListMapCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYPoolOrderListMapCell defaultReuseId]];
            cell.delegate = self;
            for (XYOrderBase* order in self.poolOrdersArray){
                if ([order.id isEqualToString:self.lastSelectedOrder]) {
                    [cell setPoolOrderData:order];
                    break;
                }
            }
            return cell;
        }
            break;
        case XYOrderListMapTypeOverTime:
        {
            //超时地图
            XYPoolOrderListMapCell *cell = [tableView dequeueReusableCellWithIdentifier:[XYPoolOrderListMapCell defaultReuseId]];
            cell.delegate = self;
            for (XYOrderBase* order in self.overTimeOrdersArray){
                if ([order.id isEqualToString:self.lastSelectedOrder]) {
                    [cell setOverTimeOrderData:order];
                    break;
                }
            }
            return cell;
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    //“今日预约”进入订单详情页
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[XYNewOrderListMapCell class]]) {
        NSString* orderId = ((XYNewOrderListMapCell*)cell).orderIdLabel.text;
        NSInteger bid = [((XYNewOrderListMapCell*)cell).bidLabel.text integerValue];
        XYOrderDetailViewController* detailViewController = [[XYOrderDetailViewController alloc]initWithOrderId:orderId brand:bid];
        [self.navigationController pushViewController:detailViewController animated:true];
    }
}

#pragma mark - annotation

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    /* 自定义userLocation对应的annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]]){
        static NSString *userLocationStyleReuseIndetifier = @"userLocationStyleReuseIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationStyleReuseIndetifier];
        if (annotationView == nil){
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:userLocationStyleReuseIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"user_heading"];
        return annotationView;
    } else if ([annotation isKindOfClass:[XYOrderMapAnnotation class]]){
        static NSString *navigationCellIdentifier = @"orderTargetLocationReuseIdentifier";
        XYOrderListAnnotationView *poiAnnotationView = (XYOrderListAnnotationView*)[self.aMapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (!poiAnnotationView){
            poiAnnotationView = [[XYOrderListAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:navigationCellIdentifier];
        }
        poiAnnotationView.canShowCallout = false;
        poiAnnotationView.draggable = false;
        poiAnnotationView.timeLabel.text = ((XYOrderMapAnnotation*)annotation).timeString;
        [self configAnnotation:poiAnnotationView annotation:((XYOrderMapAnnotation*)annotation)];
        return poiAnnotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    if ([view isKindOfClass:[XYOrderListAnnotationView class]]) {
        //点击选中
        self.lastAnnotationView.isXYSelected = false;
        self.lastAnnotationView = ((XYOrderListAnnotationView*)view);
        ((XYOrderListAnnotationView*)view).isXYSelected = true;
        XYOrderMapAnnotation* annotation = (XYOrderMapAnnotation*)self.lastAnnotationView.annotation;
        self.lastSelectedOrder = annotation.orderId;
        //展示详情
        switch (self.currentMapType) {
            case XYOrderListMapTypePoolOrder:
            case XYOrderListMapTypeOverTime:
                //如果点击的是接单/超时地图，先去取零件情况
                [self getPartsAvailability:annotation.orderId bid:annotation.bid];
                break;
            case XYOrderListMapTypeTodayAssign:
                [self updateCurrentOrderDetail];
                break;
            default:
                break;
        }
    }
}

- (void)configAnnotation:(XYOrderListAnnotationView*)poiAnnotationView annotation:(XYOrderMapAnnotation*)annotation{
    //判断标注类型
    switch (self.currentMapType)  {
        case XYOrderListMapTypePoolOrder:
            poiAnnotationView.type = XYOrderListAnnotationTypeBlue;
            break;
        case XYOrderListMapTypeTodayAssign:
        case XYOrderListMapTypeOverTime:
            poiAnnotationView.type = XYOrderListAnnotationTypeTheme;
            break;
        default:
            break;
    }
    //判断层级
    poiAnnotationView.orderLevel = annotation.orderLevel;
    //判断是否是选中点
    if (self.lastSelectedOrder) {
        BOOL isSelected = [self.lastSelectedOrder isEqualToString:annotation.orderId];
        [poiAnnotationView setIsXYSelected:isSelected];
        if (isSelected) {
            self.lastAnnotationView = poiAnnotationView;
        }
    }
}

#pragma mark - action

- (IBAction)showTodayOrders:(id)sender {
    //切换到今日订单
    if (self.currentMapType == XYOrderListMapTypeTodayAssign) {
        return;
    }
    self.currentMapType = XYOrderListMapTypeTodayAssign;
    [self onOrderMapTypeSwitched];
}

- (IBAction)findUnsignedOrders:(id)sender {
    //切换到接单地图
    if (self.currentMapType == XYOrderListMapTypePoolOrder) {
        return;
    }
    self.currentMapType = XYOrderListMapTypePoolOrder;
    [self onOrderMapTypeSwitched];
}

- (IBAction)showOverTimeOrders:(id)sender {
    //切换到超时地图
    if (self.currentMapType == XYOrderListMapTypeOverTime) {
        return;
    }
    self.currentMapType = XYOrderListMapTypeOverTime;
    [self onOrderMapTypeSwitched];
}

- (void)onOrderMapTypeSwitched{
    //切换地图时的通用操作 重新标注点+收起信息面板
    [self clearMapView];
    [self addOrderAnnotations:self.currentMapType];
    self.lastSelectedOrder = nil;
    self.panelHeight.constant = 0;
    self.navigationItem.rightBarButtonItem = (self.currentMapType!=XYOrderListMapTypePoolOrder)?nil:self.refreshButtonItem;
}

- (void)poolOrderAccepted:(XYOrderMessageDto*)orderMsg{
    //接单
    //0.给用户发短信。。。。。。
    //1.将已接订单从pool列表移除
    //2.置空订单id 收起面板
    //3.跳往订单列表
    for (XYOrderBase* order in self.poolOrdersArray) {
        if ([order.id isEqualToString:orderMsg.order_id]) {
            [XYPushDto requestMessageSendingTo:orderMsg];
            [self.poolOrdersArray removeObject:order];
            break;
        }
    }
    self.lastSelectedOrder = nil;
    self.panelHeight.constant = 0;
    [self performSelector:@selector(goToOrderList) withObject:nil afterDelay:3.0];
}

- (void)getPartsAvailability:(NSString*)orderId bid:(XYBrandType)bid{
    //检查零件是否充足
    [self showLoadingMask];
    __weak typeof(self) weakself = self;
    [[XYAPIService shareInstance]getPartsAvailability:orderId bid:bid success:^{
        [weakself updatePartsAvailabilityStatus:true order:orderId];
        [weakself updateCurrentOrderDetail];
        [weakself hideLoadingMask];
    } errorString:^(NSString *error) {
        [weakself updatePartsAvailabilityStatus:false order:orderId];
        [weakself updateCurrentOrderDetail];
        [weakself hideLoadingMask];
    }];
}

- (void)updatePartsAvailabilityStatus:(BOOL)isEnough order:(NSString*)orderId{
    for (XYOrderBase* order in self.poolOrdersArray) {
        if ([order.id isEqualToString:orderId]) {
            order.iHaveEnoughParts = isEnough;
            break;
        }
    }
}

- (void)goToOrderList{
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate.rootViewController goToOrderList];
}


#pragma mark - delelgate

- (void)startNavigationToOrder:(NSString*)orderId{
    //..导航功能 todo
}

- (void)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid{
    [XYAlertTool showConfirmCancelAlert:@"" message:@"是否确认接单？" onView:self action:^{
        [self showLoadingMask];
        __weak typeof(self) weakself = self;
        [[XYAPIService shareInstance]acceptOrder:orderId bid:bid success:^(XYOrderMessageDto *message,NSString* toast) {
            [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
            [weakself hideLoadingMask];
            [weakself showToast:toast?toast:@"接单成功！"];
            [weakself poolOrderAccepted:message];
        } errorString:^(NSString *error) {
            [weakself hideLoadingMask];
            [weakself showToast:error];
        }];
    } cancel:nil];
}

- (void)callEngineer:(NSString *)phone{
    [XYAlertTool callPhone:phone onView:self];
    
}

#pragma mark - action
- (void)refreshMapList {
    //先收起信息面板
    self.lastSelectedOrder = nil;
    self.panelHeight.constant = 0;
    //刷新待接订单
    [[XYOrderListManager sharedInstance] getPoolOrdersForMap:^(NSArray *orderList) {
        [self.poolOrdersArray removeAllObjects];
        [self.poolOrdersArray addObjectsFromArray:orderList];
        [self reloadOrderList];
    }];
    //刷新今日预约
    [[XYOrderListManager sharedInstance] getNewOrdersForMap:^(NSArray *orderList) {
        [self.incompleteOrdersArray removeAllObjects];
        [self.incompleteOrdersArray addObjectsFromArray:orderList];
        [self reloadOrderList];
    }];
    //刷新超时订单
    [[XYOrderListManager sharedInstance] getOverTimeOrdersForMap:^(NSArray *orderList) {
        [self.overTimeOrdersArray removeAllObjects];
        for(XYOrderBase* order in orderList){
            //排除：工程师信息为null的一律不要显示
            if (order.eng_mobile && order.eng_name) {
                [self.overTimeOrdersArray addObject:order];
            }
        }
        [self reloadOrderList];
    }];
    
}

/**
 *  搜索
 */
- (void)searchOrder{
    XYOrderSearchViewController* searchOrderViewController = [[XYOrderSearchViewController alloc]init];
    [self.navigationController pushViewController:searchOrderViewController animated:false];
}

- (void)refreshOrderPool{
    
    //先收起信息面板
    self.lastSelectedOrder = nil;
    self.panelHeight.constant = 0;
    
    //刷新待接订单
    [[XYOrderListManager sharedInstance] getPoolOrdersForMap:^(NSArray *orderList) {
        [self.poolOrdersArray removeAllObjects];
        [self.poolOrdersArray addObjectsFromArray:orderList];
        if ([self.poolOrdersArray count] == 0) {
            [self showToast:@"暂无可接订单"];
        }
        [self reloadOrderList];
    }];
}

- (void)refreshNewOrderPool {
    //先收起信息面板
    self.lastSelectedOrder = nil;
    self.panelHeight.constant = 0;
    
    //刷新今日预约
    [[XYOrderListManager sharedInstance] getNewOrdersForMap:^(NSArray *orderList) {
        [self.incompleteOrdersArray removeAllObjects];
        [self.incompleteOrdersArray addObjectsFromArray:orderList];
        [self reloadOrderList];
    }];
}

- (void)resetData{
    self.incompleteOrdersArray = nil;
    self.lastSelectedOrder = nil;
}

- (NSArray*)incompleteOrdersArray{
    if (!_incompleteOrdersArray) {
        _incompleteOrdersArray = [[NSMutableArray alloc]init];
    }
    return _incompleteOrdersArray;
}

- (NSMutableArray*)poolOrdersArray{
    if (!_poolOrdersArray) {
        _poolOrdersArray = [[NSMutableArray alloc]init];
    }
    return _poolOrdersArray;
}

- (NSMutableArray*)overTimeOrdersArray{
    if (!_overTimeOrdersArray) {
        _overTimeOrdersArray = [[NSMutableArray alloc]init];
    }
    return _overTimeOrdersArray;
}

/*
#pragma mark - Navigation--

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//
//    if (self.orderList.count == 0) {
//        return;
//    }
//
//    NSInteger itemWidth = scrollView.contentSize.width/self.orderList.count;//计算单个item的大小（不是screenwidth。。）
//    NSInteger page = scrollView.contentOffset.x / itemWidth;//计算页数
//
//    if (page>=0&&page<self.orderList.count) {
//
//        XYOrderBase* pageOrder = [self.orderList objectAtIndex:page];
//        if([pageOrder.id isEqualToString:[XYOrderListManager sharedInstance].lastSelectedOrder]){
//            return;//如果停留在原来的cell上 啥都别做
//        }
//
//        scrollView.scrollEnabled = false;
//
//        NSString* lastOrderId = [[XYOrderListManager sharedInstance].lastSelectedOrder copy];
//        [XYOrderListManager sharedInstance].lastSelectedOrder = pageOrder.id;
//        if(lastOrderId){//否则先移除掉原先的选中cell
//            for (id<MAAnnotation> anno in self.aMapView.annotations) {
//                if ([anno.subtitle isEqualToString:[XYOrderListManager sharedInstance].lastSelectedOrder]) {
//                    [self.aMapView removeAnnotation:anno];
//                    break;
//                }
//            }
//        }
//        for(XYOrderBase* order in self.orderList){
//            //再把老cell和新cell一起加进去 相当于刷新 TT为什么没有刷新api
//            if ([order.id isEqualToString:lastOrderId] || [order.id isEqualToString:pageOrder.id] ) {
//                [self addAnnotationByOrder:order];
//            }
//        }
//
//        [self updateMapVisibleView];//更新显示范围
//
//        scrollView.scrollEnabled = true;
//
//    }
//}


@end
