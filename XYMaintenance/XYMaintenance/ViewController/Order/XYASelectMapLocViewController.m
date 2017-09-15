//
//  XYASelectMapLocViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYASelectMapLocViewController.h"
#import "CusAnnotationView.h"
#import "AMapXYUtility.h"


@interface XYASelectMapLocViewController ()<MAMapViewDelegate, AMapSearchDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL hasLocated;
@property (nonatomic, strong) MAPointAnnotation* pointAnnotation;
@end

@implementation XYASelectMapLocViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    self.mapView.delegate = self;
    self.search.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}


#pragma mark - override

-(void)initializeUIElements
{
    [self shouldShowBackButton:true];
    self.hasLocated = false;
    
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self clearMapView];
    self.mapView.showsUserLocation = true;
    [self.view addSubview:self.mapView];
    
    [self initGestureRecognizer];
    
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
    [locBtn addTarget:self action:@selector(startLocating) forControlEvents:UIControlEventTouchUpInside];
    locBtn.layer.cornerRadius = 5.0f;
    locBtn.layer.masksToBounds = true;
    [self.view addSubview:locBtn];
    
}

-(void)clearMapView{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

#pragma mark - location

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
    if (self.hasLocated) {
        return;
    }
    
    self.hasLocated = true;
    self.mapView.centerCoordinate = userLocation.location.coordinate;
    self.mapView.zoomLevel = self.mapView.zoomLevel - 0.5;
}

- (void)startLocating{
   self.mapView.centerCoordinate = self.mapView.userLocation.location.coordinate;
   self.mapView.showsUserLocation = true;
}

- (void)initGestureRecognizer{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPress:)];
    longPress.minimumPressDuration = 0.2;
    longPress.delegate = self;
    
    [self.view addGestureRecognizer:longPress];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan){
        CLLocationCoordinate2D coordinate = [self.mapView convertPoint:[longPress locationInView:self.view]
          toCoordinateFromView:self.mapView];
        
        [self selectPointAtLocation:coordinate];
    }
}

#pragma mark - annotation

- (void)selectPointAtLocation:(CLLocationCoordinate2D)location{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    
    self.pointAnnotation = [[MAPointAnnotation alloc]init];
    self.pointAnnotation.coordinate = location;
    
    [self.mapView addAnnotation:self.pointAnnotation];
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *annotationId = @"annotationId";
        
        CusAnnotationView *poiAnnotationView = (CusAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:annotationId];
       
        if (poiAnnotationView == nil){
            poiAnnotationView = [[CusAnnotationView alloc] initWithAnnotation:annotation
                                                                 reuseIdentifier:annotationId];
        }
        poiAnnotationView.canShowCallout = NO;
        return poiAnnotationView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view{
    [self searchGeoNameOfCoordinate:view.annotation.coordinate];
}

#pragma mark - geocode

-(void)searchGeoNameOfCoordinate:(CLLocationCoordinate2D)location{
    [self showLoadingMask];
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:location.latitude longitude:location.longitude];
    regeo.requireExtension = YES;
    [self.search AMapReGoecodeSearch:regeo];
}


/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response{
    [self hideLoadingMask];
    if (response.regeocode != nil){
        if ([self.delegate respondsToSelector:@selector(onLocationSelected:coordinate:)]) {
            [self.delegate onLocationSelected:response.regeocode.formattedAddress coordinate:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude)];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(onLocationSelected:coordinate:)]) {
            [self.delegate onLocationSelected:nil coordinate:CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude)];//没检索到中文的地址，直接返回
        }
    }
    [self goBack];
}


@end
