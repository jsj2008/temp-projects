//
//  XYTrafficSelectMapViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficSelectMapViewController.h"
#import "XYTrafficSearchTipViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "GeocodeAnnotation.h"
#import "AMapXYUtility.h"
#import "XYTrafficPOICell.h"

@interface XYTrafficSelectMapViewController ()<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,MAMapViewDelegate, AMapSearchDelegate,UIGestureRecognizerDelegate,XYTrafficSearchTipDelegate>

@property (nonatomic, assign) BOOL hasLocated;
@property (nonatomic, strong) NSMutableArray *nearbyLocs;
@property (nonatomic, strong) NSString* userLocation;

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) MAMapView *aMapView;
@property (nonatomic, strong) UITableView* poiLocTableView;
@end

@implementation XYTrafficSelectMapViewController

- (id)init
{
    if (self = [super init]){
        self.nearbyLocs = [[NSMutableArray alloc]init];
        self.hasLocated = false;
        self.userLocation = TT_LOADING_LOC;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.search) {
        self.search.delegate = self;
    }
    if (self.aMapView) {
        self.aMapView.delegate = self;
        [self.aMapView setZoomLevel:self.aMapView.maxZoomLevel - 5];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    self.aMapView.delegate = nil;
    self.search.delegate = nil;
}

#pragma - mark override

- (void)initializeUIElements{
    [self initAmapRelated];
    [self initSearchBar];
    [self shouldShowBackButton:true];
    [self initFooterViews];
    [self initGestureRecognizer];
}


#pragma mark - Initialization

- (void)initAmapRelated{
    self.aMapView.frame = self.view.bounds;
    self.aMapView.delegate = self;
    [self.view addSubview:self.aMapView];
    self.aMapView.showsUserLocation = true;
}

- (void)initSearchBar{
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth - 80, NAVI_BAR_HEIGHT-10)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    self.searchBar.placeholder  = @"请输入地铁站/小区/商圈等";
}

- (void)initFooterViews{
    self.poiLocTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenFrameHeight - NAVI_BAR_HEIGHT- 150, ScreenWidth, 150)];
    self.poiLocTableView.backgroundColor = BACKGROUND_COLOR;
    self.poiLocTableView.dataSource = self;
    self.poiLocTableView.delegate = self;
    self.poiLocTableView.separatorColor = XY_COLOR(210,218,228);
    [self.poiLocTableView setTableFooterView:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(210,218,228)]];
    [self.view addSubview:self.poiLocTableView];
}

#pragma mark - property

- (MAMapView*)aMapView{
    if (!_aMapView) {
        _aMapView = [[MAMapView alloc]init];
        [_aMapView setZoomLevel:_aMapView.maxZoomLevel - 5];
        _aMapView.delegate = self;
        _aMapView.showsUserLocation = true;
        _aMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        _aMapView.pausesLocationUpdatesAutomatically = false;
    }
    return _aMapView;
}


#pragma mark - searchbar

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self goToSearchTips];
    return false;
}

#pragma mark - mapView

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (self.hasLocated) {
        return;
    }
    self.hasLocated = true;
    [self.aMapView setCenterCoordinate:self.aMapView.userLocation.location.coordinate animated:true];
    [self searchGeoNameOfCoordinate:userLocation.location.coordinate];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nearbyLocs.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XYTrafficPOICell* cell = [tableView dequeueReusableCellWithIdentifier:[XYTrafficPOICell defaultReuseId]];
    if (!cell) {
        cell = [[[NSBundle mainBundle]loadNibNamed:[XYTrafficPOICell defaultReuseId] owner:self options:nil]lastObject];
        [cell.selectButton addTarget:self action:@selector(selectLoc:) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.poiIdLabel.text = [NSString stringWithFormat:@"%03ld",(long)indexPath.row];
    if (indexPath.row == 0) {
        cell.addressLabel.text = self.userLocation;
    }else{
        cell.addressLabel.text = self.nearbyLocs[indexPath.row-1];
    }
    cell.selectButton.tag = indexPath.row-1;
    if([cell.addressLabel.text isEqualToString:TT_LOADING_LOC]){
        cell.selectButton.enabled = false;
    }else{
       cell.selectButton.enabled = true;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [XYTrafficPOICell defaultHeight];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - Action

-(void)goToSearchTips{
    XYTrafficSearchTipViewController* searchTipViewController = [[XYTrafficSearchTipViewController alloc]init];
    searchTipViewController.delegate = self;
    searchTipViewController.search = self.search;
    [self.navigationController pushViewController:searchTipViewController animated:false];
}

-(void)selectLoc:(UIButton*)btn{
    if (btn.tag<0) {
        [self.locDelegate onTrafficLocationSelected:self.userLocation];
    }else{
      [self.locDelegate onTrafficLocationSelected:self.nearbyLocs[btn.tag]];
    }
}

/* 清除annotation. */
- (void)clear{
    [self.aMapView removeAnnotations:self.aMapView.annotations];
}


-(void)onLocationTipSelected:(NSString *)locName{
   [self.locDelegate onTrafficLocationSelected:locName];
}


#pragma mark - AMapSearchDelegate

/* 根据中心点坐标来搜周边的POI. */
- (void)searchPoiByCenterCoordinate:(AMapGeoPoint*)point{
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    request.location            = point;
    request.sortrule            = 1;
    request.requireExtension    = false;
    [self.search AMapPOIAroundSearch:request];
}

/* POI 搜索回调. */
- (void)onPlaceSearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)respons{
    if (respons.pois.count == 0){
        return;
    }
    
    [self.nearbyLocs removeAllObjects];
    [respons.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        [self.nearbyLocs addObject:obj.name];
        //字符串only
    }];
    [self.poiLocTableView reloadData];
}

#pragma mark - 地理编码

/* 根据坐标搜索地名 （当前用户地址）*/
-(void)searchGeoNameOfCoordinate:(CLLocationCoordinate2D)location{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
        if (response.regeocode && response.regeocode.formattedAddress){
           self.userLocation = response.regeocode.formattedAddress;
        }else{
            self.userLocation = TT_LOADING_LOC;
        }
    [self.poiLocTableView reloadData];
}


#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]]){
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.aMapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil){
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:geoCellIdentifier];
        }
        poiAnnotationView.canShowCallout   = false;
        return poiAnnotationView;
    }
    return nil;
}

#pragma - mark 长按选点

- (void)initGestureRecognizer{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.5;
    longPress.delegate = self;
    [self.view addGestureRecognizer:longPress];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan){
        CLLocationCoordinate2D coordinate = [self.aMapView convertPoint:[longPress locationInView:self.view]
                                                  toCoordinateFromView:self.aMapView];
        
        [self selectPointAtLocation:coordinate];
    }
}

- (void)selectPointAtLocation:(CLLocationCoordinate2D)location{
    NSArray* array = [NSArray arrayWithArray:self.aMapView.annotations];
    [self.aMapView removeAnnotations:array];
    MAPointAnnotation* pointAnnotation = [[MAPointAnnotation alloc]init];
    pointAnnotation.coordinate = location;
    [self.aMapView addAnnotation:pointAnnotation];
    [self searchGeoNameOfCoordinate:location];
    [self searchPoiByCenterCoordinate:[AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude]];
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
