//
//  XYTargetLocationViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/26.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTargetLocationViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "XYTargetLocFooterView.h"
#import "XYASearchRouteViewController.h"
#import <MapKit/MapKit.h>
#import "GeocodeAnnotation.h"
#import "XYAPPSingleton.h"


@interface XYTargetLocationViewController ()<AMapSearchDelegate,MAMapViewDelegate,UIActionSheetDelegate>
@property (copy,nonatomic) NSString* targetAddress;
@property (copy,nonatomic) NSString* cityName;
@property (assign,nonatomic) CLLocationCoordinate2D targetCoordinate;
@property (assign,nonatomic) CLLocationCoordinate2D startCoordinate;

@property (assign,nonatomic)  BOOL hasLocated;
@property (nonatomic, strong) NSMutableArray* localMapsArray;
@property (strong,nonatomic) XYTargetLocFooterView* footerView;

@property (nonatomic, strong) MAMapView *mapView;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (strong, nonatomic) AMapGeocode* searchResultCode;
@end

@implementation XYTargetLocationViewController

#pragma mark - life cycle

-(id)initWithTargetAddress:(NSString*)address area:(NSString*)city{
    if (self = [super init]){
        _targetAddress = [address copy];
        _cityName = [city copy];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    self.mapView.delegate = self;
    self.search.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.mapView){
        self.mapView.frame = self.view.bounds;
        [self.view insertSubview:self.mapView atIndex:0];
        [self.mapView setZoomLevel:self.mapView.maxZoomLevel - 5];
        [self clearMapView];
        if(self.searchResultCode){
            GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:self.searchResultCode];
            [self.mapView addAnnotation:geocodeAnnotation];
            [self.mapView setCenterCoordinate:[geocodeAnnotation coordinate] animated:YES];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

-(void)dealloc{
    self.mapView.delegate = nil;
    self.search.delegate = nil;
}

#pragma mark - property

- (NSMutableArray*)localMapsArray{
    if (!_localMapsArray) {
        _localMapsArray = [[NSMutableArray alloc]init];
        [_localMapsArray addObject:TT_OPEN_APPLE_MAP];
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]){
            [_localMapsArray addObject:TT_OPEN_BAIDU_MAP];
        }
        if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]){
            [_localMapsArray addObject:TT_OPEN_AMAP];
        }
    }
    return _localMapsArray;
}

-(MAMapView*)mapView{
    if (!_mapView) {
        _mapView = [[MAMapView alloc]init];
        [_mapView setZoomLevel:_mapView.maxZoomLevel - 5];
        _mapView.delegate = self;
        _mapView.showsUserLocation = true;
        _mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        _mapView.pausesLocationUpdatesAutomatically = false;
    }
    return _mapView;
}

- (AMapSearchAPI*)search{
    if (!_search) {
        [AMapServices sharedServices].apiKey = GAODE_KEY;
        _search = [[AMapSearchAPI alloc]init];
    }
    return _search;
}

- (void)clearMapView{
    
    for (id<MAAnnotation> anno in self.mapView.annotations) {
        if (![anno isKindOfClass:[MAUserLocation class]]) {
            [self.mapView removeAnnotation:anno];
        }
    }
    [self.mapView removeOverlays:self.mapView.overlays];
    self.mapView.showsUserLocation = true;
}

-(XYTargetLocFooterView*)footerView{
    if (!_footerView) {
        _footerView = [[XYTargetLocFooterView alloc]init];
        _footerView.frame = CGRectMake(0, self.view.bounds.size.height - _footerView.frame.size.height, SCREEN_WIDTH, _footerView.frame.size.height);
        _footerView.addressLabel.text = self.targetAddress;
        [_footerView.viewRouteButton addTarget:self action:@selector(goToRouteGuidance) forControlEvents:UIControlEventTouchUpInside];
        [_footerView.deviceMapButton addTarget:self action:@selector(goToDeviceMap) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

#pragma mark - override 

- (void)initializeUIElements{
    
    [self shouldShowBackButton:true];
    //地图初始化
    self.hasLocated = false;
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = true;
    [self.view addSubview:self.mapView];
    self.search.delegate = self;
    //头部按钮
    UIButton* backBtn = [[UIButton alloc]initWithFrame:CGRectMake(15, 15, 32, 32)];
    backBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [backBtn setImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius = 5.0f;
    backBtn.layer.masksToBounds = true;
    [self.view addSubview:backBtn];
    UIButton* locBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 15 - 32, 15, 32, 32)];
    locBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    [locBtn setImage:[UIImage imageNamed:@"btn_loc"] forState:UIControlStateNormal];
    [locBtn addTarget:self action:@selector(moveToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    locBtn.layer.cornerRadius = 5.0f;
    locBtn.layer.masksToBounds = true;
    [self.view addSubview:locBtn];
    //底部视图
    [self.view addSubview:self.footerView];
    //开始搜索
    [self searchGeoCodeOfCurrentTarget];
}

#pragma mark - map related

-(void)moveToUserLocation{
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
    [self startLocating];
}

- (void)startLocating{
    self.hasLocated = false;
    self.mapView.showsUserLocation = true;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    [self hideLoadingMask];
    if (self.hasLocated){
        return;
    }
    self.hasLocated = true;
    self.mapView.showsUserLocation = true;
    self.startCoordinate = userLocation.location.coordinate;
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    [self hideLoadingMask];
    self.hasLocated = true;
    [self showToast:error.localizedDescription];
}

#pragma mark - MAMapViewDelegate

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[GeocodeAnnotation class]]){
        static NSString *geoCellIdentifier = @"geoCellIdentifier";
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:geoCellIdentifier];
        if (poiAnnotationView == nil){
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation
                                                        reuseIdentifier:geoCellIdentifier];
        }
        poiAnnotationView.canShowCallout = false;
        return poiAnnotationView;
    }
    return nil;
}

#pragma mark - geo code

- (void)searchGeoCodeOfCurrentTarget{
    [self showLoadingMask];
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = [NSString stringWithFormat:@"%@",self.targetAddress];
    geo.city = self.cityName;
    [self.search AMapGeocodeSearch:geo];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    
    [self hideLoadingMask];
    
    if (response.geocodes.count == 0){
        [self showToast:TT_NO_GEO_RESULT];
        [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
    }
    else{

        AMapGeocode* code =  [response.geocodes objectAtIndex:0];
       
        if ([code.formattedAddress isEqualToString:code.city]) {
            [self showToast:TT_NO_GEO_RESULT];
            [self performSelector:@selector(goBack) withObject:nil afterDelay:2.0];
            return;
        }
        
        self.searchResultCode = code;
        self.targetCoordinate = CLLocationCoordinate2DMake(code.location.latitude, code.location.longitude);
        //self.targetAddress = code.formattedAddress;
        
        GeocodeAnnotation *geocodeAnnotation = [[GeocodeAnnotation alloc] initWithGeocode:code];
        [self.mapView addAnnotation:geocodeAnnotation];
        [self.mapView setCenterCoordinate:[geocodeAnnotation coordinate] animated:YES];
        [self startLocating];
    }
}

#pragma mark - method

-(void)goToRouteGuidance{
    if(!self.hasLocated){
        [self showToast:@"定位失败，请点击地图右上角重新定位"];
        return;
    }
    XYASearchRouteViewController* searchRouteViewController = [[XYASearchRouteViewController alloc]initWithTargetAddress:self.targetAddress targetLocation:self.targetCoordinate myLocation:self.startCoordinate city:self.cityName];
    searchRouteViewController.mapView = self.mapView;
    searchRouteViewController.search = self.search;
    [self.navigationController pushViewController:searchRouteViewController animated:true];
}

#pragma mark - device map

-(void)goToDeviceMap{
    if ([self.localMapsArray count]>1) {
        UIActionSheet* sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
        for (NSString* str in self.localMapsArray) {
            [sheet addButtonWithTitle:str];
        }
        [sheet showFromTabBar:self.tabBarController.tabBar];
    }else{
        [self openAppleMap];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    NSString* title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:TT_OPEN_APPLE_MAP]) {
        [self openAppleMap];
    }else if ([title isEqualToString:TT_OPEN_BAIDU_MAP]) {
        [self openBaiduMap];
    }else if ([title isEqualToString:TT_OPEN_AMAP]) {
        [self openGodMap];
    }
}


-(void)openAppleMap{
    /**
     *  苹果
     */
    MKMapItem *currentLocation = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:self.targetCoordinate addressDictionary:nil]];
    toLocation.name = [NSString stringWithFormat:@"%@%@",self.cityName,self.targetAddress];
    [MKMapItem openMapsWithItems:@[currentLocation, toLocation]
                   launchOptions:@{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeKey,MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]}];
}

-(void)openGodMap{
    /**
     *  高德
     */
    AMapPOIConfig *config = [AMapPOIConfig new];
    config.appName = [XYAPPSingleton sharedInstance].appName;
    config.appScheme = [XYAPPSingleton sharedInstance].appScheme;
    config.keywords = [NSString stringWithFormat:@"%@%@",self.cityName,self.targetAddress];
    [AMapURLSearch openAMapPOISearch:config];
}

-(void)openBaiduMap{
    /**
     *  百度
     */
   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"baidumap://map/place/search?query=%@",[[NSString stringWithFormat:@"%@%@",self.cityName,self.targetAddress] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]]];
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
