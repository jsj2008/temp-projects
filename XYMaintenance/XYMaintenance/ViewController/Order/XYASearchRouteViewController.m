//
//  XYASearchRouteViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYASearchRouteViewController.h"
#import "XYRouteHeaderView.h"
#import "XYImageSegmentedControl.h"
#import "XYRouteCell.h"
#import "XYASelectMapLocViewController.h"
#import "XYARouteDetailViewController.h"

@interface XYASearchRouteViewController ()<XYASelectMapLocationDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate, AMapSearchDelegate,MAMapViewDelegate,XYRouteHeaderViewDelegate>{
    NSString* _startAddress;
    CLLocationCoordinate2D _startCoordinate;
    NSString* _targetAddress;
    CLLocationCoordinate2D _targetCoordinate;
    NSString* _cityName;
    BOOL _hasUpdatedUserLocation;
}

@property(strong,nonatomic)XYRouteHeaderView* routeHeaderView;
@property(strong,nonatomic)XYImageSegmentedControl* segmentControl;
@property(strong,nonatomic)UITableView* tableView;
@property(strong,nonatomic)UIView* backgroundView;
@property(strong,nonatomic)UIActionSheet* actionSheet;
@property(strong,nonatomic)NSMutableDictionary* routeCacheDictionary;
@end

@implementation XYASearchRouteViewController

-(id)initWithTargetAddress:(NSString*)tAddress targetLocation:(CLLocationCoordinate2D)tLocation myLocation:(CLLocationCoordinate2D)mLocation city:(NSString*)area{
    if (self = [super init]) {
        _targetAddress = [tAddress copy];
        _targetCoordinate = tLocation;
        _startAddress = @"我的位置";
        _startCoordinate = mLocation;
        _cityName = [area copy];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.actionSheet = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mapView.delegate = self;
    self.search.delegate = self;
}

#pragma mark - override

- (void)initializeData{
    _hasUpdatedUserLocation = false;
    self.search.delegate = self;
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"查看路线";
    [self shouldShowBackButton:true];
    //视图
    [self.view addSubview:self.routeHeaderView];
    UIView* devider = [[UIView alloc]initWithFrame:CGRectMake(0, self.routeHeaderView.frame.size.height, SCREEN_WIDTH, LINE_HEIGHT)];
    devider.backgroundColor = XY_COLOR(194,205,218);
    [self.view addSubview:devider];
    UIView* segBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, self.routeHeaderView.frame.size.height + LINE_HEIGHT, SCREEN_WIDTH, 60)];
    [segBackgroundView addSubview:self.segmentControl];
    [self.view addSubview:segBackgroundView];
    self.tableView.frame = CGRectMake(0, segBackgroundView.frame.size.height + segBackgroundView.frame.origin.y, SCREEN_WIDTH, SCREEN_FRAME_HEIGHT - NAVI_BAR_HEIGHT - (segBackgroundView.frame.size.height + segBackgroundView.frame.origin.y));
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.backgroundView];
    self.backgroundView.hidden = true;
    self.mapView.delegate = self;
    //开始搜索
    [self searchForRouteLines];
}

- (void)goBack{
    self.mapView.delegate = nil;
    self.search.delegate = nil;
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - property 

- (NSDictionary*)routeCacheDictionary{
    if (!_routeCacheDictionary) {
        _routeCacheDictionary = [[NSMutableDictionary alloc]init];
        [_routeCacheDictionary setObject:@[] forKey:@(XY_BUS)];
        [_routeCacheDictionary setObject:@[] forKey:@(XY_DRIVING)];
        [_routeCacheDictionary setObject:@[] forKey:@(XY_WAKLING)];
    }
    return _routeCacheDictionary;
}

- (XYRouteHeaderView*)routeHeaderView{
    if (!_routeHeaderView) {
        _routeHeaderView = [[XYRouteHeaderView alloc]init];
        _routeHeaderView.delegate = self;
        _routeHeaderView.startLocLabel.text = _startAddress;
        _routeHeaderView.endLocLabel.text = _targetAddress;
        UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showActionSheet)];
        [_routeHeaderView addGestureRecognizer:tapGesture];
    }
    return _routeHeaderView;
}

- (XYImageSegmentedControl*)segmentControl{
    if (!_segmentControl) {
        _segmentControl = [[XYImageSegmentedControl alloc]initWithSectionTitles:@[@"bus",@"walk",@"car"]];
        _segmentControl.frame = CGRectMake(38,0, SCREEN_WIDTH - 76, 65);
        [_segmentControl addTarget:self action:@selector(onSegmentControlSelected) forControlEvents:UIControlEventValueChanged];
    }
    return _segmentControl;
}

- (UITableView*)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]init];
        _tableView.backgroundColor = XY_COLOR(238,240,243);
        _tableView.separatorColor = XY_COLOR(217,223,231);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView setTableHeaderView:[XYWidgetUtil getSingleLine]];
        [_tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    }
    return _tableView;
}

- (UIView*)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]initWithFrame:self.tableView.bounds];
        _backgroundView.backgroundColor = self.tableView.backgroundColor;
        UIImageView* imgView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 213)/2 , 50, 213, 78)];
        imgView.image = [UIImage imageNamed:@"bg_no_route"];
        [_backgroundView addSubview:imgView];
        UILabel* noteLabel = [[UILabel alloc]init];
        noteLabel.textColor = LIGHT_TEXT_COLOR;
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc]initWithString:@"离家很近，请查看步行路线"];
        NSRange range= [@"离家很近，请查看步行路线" rangeOfString:@"查看步行路线"];
        [str addAttribute:NSForegroundColorAttributeName value:XY_COLOR(26,128,255) range:range];
        [str addAttribute:NSFontAttributeName value:SIMPLE_TEXT_FONT range:NSMakeRange(0, str.length)];
        noteLabel.attributedText = str;
        CGSize size = [noteLabel.attributedText size];
        noteLabel.frame = CGRectMake((SCREEN_WIDTH - size.width)/ 2, imgView.frame.size.height + imgView.frame.origin.y + 20, size.width, size.height);
        [_backgroundView addSubview:noteLabel];
    }
    return _backgroundView;
}


#pragma mark - 按钮逻辑

- (void)onReverseButtonClicked{
    [self resetCacheAndGetNewRoute];
}

- (void)resetMyLocation{
    self.routeHeaderView.startLocLabel.text = _startAddress;
}

- (void)onSegmentControlSelected{
    [self reloadTableView];
    if ([[self getArrayFromCacheWithIndex:self.segmentControl.selectedIndex] count] <= 0){
        [self searchForRouteLines];
    }
}

- (void)showActionSheet{
    if (!self.actionSheet){
        self.actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我的位置",@"地图选点",nil];
    }
    [self.actionSheet showFromTabBar:self.tabBarController.tabBar];
}

- (void)resetCacheAndGetNewRoute{
    self.routeCacheDictionary = nil;
    [self reloadTableView];
    [self searchForRouteLines];
}

- (NSArray*)getArrayFromCacheWithIndex:(NSInteger)index{
    return [self.routeCacheDictionary objectForKey:@(index)];
}

- (void)searchForRouteLines{
    switch (self.segmentControl.selectedIndex) {
        case XY_BUS:
            [self searchForBusLines];
            break;
        case XY_DRIVING:
            [self searchForDrivingLines];
            break;
        case XY_WAKLING:
            [self searchForWalkingLines];
            break;
        default:
            break;
    }
}

- (void)searchForBusLines{
    
    AMapTransitRouteSearchRequest *navi = [[AMapTransitRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    navi.city             = _cityName;

    if (!self.routeHeaderView.isReversed){
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                               longitude:_startCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                            longitude:_targetCoordinate.longitude];
    }else{
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                               longitude:_targetCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                                    longitude:_startCoordinate.longitude];
    }
    [self.search AMapTransitRouteSearch:navi];
}

-(void)searchForDrivingLines{
    
    AMapDrivingRouteSearchRequest *navi = [[AMapDrivingRouteSearchRequest alloc] init];
    navi.requireExtension = YES;
    
    if (!self.routeHeaderView.isReversed){
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                               longitude:_startCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                                    longitude:_targetCoordinate.longitude];
    }else{
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                               longitude:_targetCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                                    longitude:_startCoordinate.longitude];
    }
    
    [self.search AMapDrivingRouteSearch:navi];
}

-(void)searchForWalkingLines{
    AMapWalkingRouteSearchRequest *navi = [[AMapWalkingRouteSearchRequest alloc] init];
    navi.multipath = 1;
    
    if (!self.routeHeaderView.isReversed){
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                               longitude:_startCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                                    longitude:_targetCoordinate.longitude];
    }else{
        /* 出发点. */
        navi.origin = [AMapGeoPoint locationWithLatitude:_targetCoordinate.latitude
                                               longitude:_targetCoordinate.longitude];
        /* 目的地. */
        navi.destination = [AMapGeoPoint locationWithLatitude:_startCoordinate.latitude
                                                    longitude:_startCoordinate.longitude];
    }
    
    [self.search AMapWalkingRouteSearch:navi];
}

#pragma mark - route search call back

- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response{
    XY_ROUTE_LINE_TYPE type = XY_UNKNOWN;
    if ([request isKindOfClass:[AMapTransitRouteSearchRequest class]]){
        type = XY_BUS;
    }else if ([request isKindOfClass:[AMapDrivingRouteSearchRequest class]]){
        type = XY_DRIVING;
    }else if ([request isKindOfClass:[AMapWalkingRouteSearchRequest class]]){
        type = XY_WAKLING;
    }else{
        return;
    }
    if (response.route!= nil){
        [self.routeCacheDictionary setObject:[XYRouteBaseDto routeBaseArrayFromRouteLines:response.route type:type] forKey:@(type)];
    }else{
        [self.routeCacheDictionary setObject:@[] forKey:@(type)];
    }
    [self reloadTableView];
    return;
}

#pragma mark - locationService

- (void)startLocating{
    [self showLoadingMask];
    _hasUpdatedUserLocation = false;
    self.mapView.showsUserLocation = true;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (_hasUpdatedUserLocation){
        return;
    }
    [self hideLoadingMask];
    _hasUpdatedUserLocation = true;
    _startCoordinate = userLocation.location.coordinate;
    _startAddress = @"我的位置";
    [self resetMyLocation];
    [self resetCacheAndGetNewRoute];
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self hideLoadingMask];
    _hasUpdatedUserLocation = true;
    [self showToast:error.localizedDescription];
}

-(void)onLocationSelected:(NSString*)locationName coordinate:(CLLocationCoordinate2D)coordinate{
    _startCoordinate = coordinate;
    _startAddress = locationName ? locationName : @"";
    [self resetMyLocation];
    [self resetCacheAndGetNewRoute];
}

#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        _startCoordinate = _mapView.userLocation.location.coordinate;
        _startAddress = @"我的位置";
        [self resetMyLocation];
        [self resetCacheAndGetNewRoute];
    }
    else if (buttonIndex == 1){
        XYASelectMapLocViewController* selectMapViewController = [[XYASelectMapLocViewController alloc]init];
        selectMapViewController.mapView = self.mapView;
        selectMapViewController.search = self.search;
        selectMapViewController.delegate = self;
        [self.navigationController pushViewController:selectMapViewController animated:true];
    }
}

#pragma mark - tableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self getArrayFromCacheWithIndex:self.segmentControl.selectedIndex] count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYRouteCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYRouteCell defaultReuseId]];
    if (!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:[XYRouteCell defaultReuseId] owner:self options:nil]lastObject];
    }
    [cell setData:[[self getArrayFromCacheWithIndex:self.segmentControl.selectedIndex] objectAtIndex:indexPath.row] index:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYRouteCell defaultHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    XYRouteBaseDto* dto = [[self getArrayFromCacheWithIndex:self.segmentControl.selectedIndex] objectAtIndex:indexPath.row];
        if (dto.type == XY_BUS){
            XYARouteDetailViewController* routeDetailViewController = [[XYARouteDetailViewController alloc]initWithTransit:dto start:CLLocationCoordinate2DMake(dto.startLatitude, dto.startLongtitude) end:_targetCoordinate];
            routeDetailViewController.mapView = self.mapView;
            [self.navigationController pushViewController:routeDetailViewController animated:true];
        }else{
            XYARouteDetailViewController* routeDetailViewController = [[XYARouteDetailViewController alloc]initWithPath:dto type:dto.type start:CLLocationCoordinate2DMake(dto.startLatitude, dto.startLongtitude) end:_targetCoordinate];
            routeDetailViewController.mapView = self.mapView;
            [self.navigationController pushViewController:routeDetailViewController animated:true];
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

- (void)reloadTableView{
    [self.tableView reloadData];
    if (self.segmentControl.selectedIndex == XY_BUS){
        if ([[self getArrayFromCacheWithIndex:self.segmentControl.selectedIndex] count]<=0){
            self.backgroundView.hidden = false;
        }else{
            self.backgroundView.hidden = true;
        }
    }else{
        self.backgroundView.hidden = true;
    }
}



@end
