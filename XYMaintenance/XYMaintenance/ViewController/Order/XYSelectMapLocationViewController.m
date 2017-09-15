//
//  XYSelectMapLocationViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectMapLocationViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface XYSelectMapLocationViewController ()<BMKMapViewDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView* _mapView;
    BMKGeoCodeSearch* _geoSearchEngine;
    BMKPointAnnotation* _pointAnnotation;
}

@end

@implementation XYSelectMapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    _geoSearchEngine.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;
    _geoSearchEngine.delegate = nil;
}

#pragma mark - override

-(void)initializeUIElements
{
    self.navigationItem.title = @"地图选点";
    [self shouldShowBackButton:true];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(startLocating)];
    
    _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    _geoSearchEngine = [[BMKGeoCodeSearch alloc]init];
    
    [self showUserLocationRegionWithLocation:CLLocationCoordinate2DMake(31.199256,121.482678)];
}

#pragma mark - locating service

- (void)startLocating
{
    [self.delegate mapSelectionstartLocating];
}

-(void)setCurrentLocationOnMap:(BMKUserLocation*)userLocation
{
    if (_mapView.delegate == self)
    {
        [_mapView updateLocationData:userLocation];
        [self showUserLocationRegionWithLocation:userLocation.location.coordinate];
    }
}

-(void)showLocatingFailure:(NSString*)errorString
{
    if (_mapView.delegate == self)
    {
        [self showToast:errorString];
    }
}

- (void)selectPointAtLocation:(CLLocationCoordinate2D)location
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    _pointAnnotation = [[BMKPointAnnotation alloc]init];
    _pointAnnotation.coordinate = location;
    _pointAnnotation.title = @"点击选中该位置";
    [_mapView addAnnotation:_pointAnnotation];
    _pointAnnotation = nil;
}

-(void)showUserLocationRegionWithLocation:(CLLocationCoordinate2D)coords
{
        BMKCoordinateRegion region;
        region.center = coords;
        region.span.latitudeDelta = 0.007;
        region.span.longitudeDelta = 0.007;
        [_mapView setRegion:region];
}

-(void)searchGeoNameOfCoordinate:(CLLocationCoordinate2D)location
{
    [self showLoadingMask];
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = location;
    BOOL flag = [_geoSearchEngine reverseGeoCode:reverseGeocodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        [self hideLoadingMask];
        [self.delegate onLocationSelected:nil coordinate:location];//没检索到中文的地址，直接返回
    }

}

#pragma mark - map view delegate

- (void)mapView:(BMKMapView *)mapView onClickedMapPoi:(BMKMapPoi*)mapPoi
{
    [self selectPointAtLocation:mapPoi.pt];
}

- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate
{
    [self selectPointAtLocation:coordinate];
}

- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    [self showToast:TT_LOCATION_FAIL];
}

#pragma mark - annotation

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    BMKAnnotationView* view = [mapView dequeueReusableAnnotationViewWithIdentifier:@"renameMark"];
    if (view == nil)
    {
        view = [[BMKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"renameMark"];
        ((BMKPinAnnotationView*)view).pinColor = BMKPinAnnotationColorRed;
        ((BMKPinAnnotationView*)view).canShowCallout = true;
    }
    
    return view;
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    [self searchGeoNameOfCoordinate:view.annotation.coordinate];
}

#pragma mark - geocode

-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self hideLoadingMask];
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        NSLog(@"you select %f,%f",result.location.latitude,result.location.longitude);
        [self.delegate onLocationSelected:result.address coordinate:result.location];
    }
    else
    {
        [self.delegate onLocationSelected:nil coordinate:result.location];//没检索到中文的地址，直接返回
    }
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
