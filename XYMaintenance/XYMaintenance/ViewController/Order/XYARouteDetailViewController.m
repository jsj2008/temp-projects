//
//  XYARouteDetailViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYARouteDetailViewController.h"
#import "MANaviRoute.h"
#import "AMapXYUtility.h"
#import "XYRouteDetailPanel.h"

@interface XYARouteDetailViewController ()<MAMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)XYRouteDetailPanel* detailPanel;
@property(strong,nonatomic)UIButton* upDownBtn;
@property(assign,nonatomic)CLLocationCoordinate2D startLocation;
@property(assign,nonatomic)CLLocationCoordinate2D endLocation;
@property(assign,nonatomic)XY_ROUTE_LINE_TYPE type;
@property(nonatomic) MANaviRoute * naviRoute;
@property(strong,nonatomic) XYRouteBaseDto* routeBase;
@end

@implementation XYARouteDetailViewController

-(id)initWithTransit:(XYRouteBaseDto*)dto start:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end{
    
    if (self = [super init]){
        self.naviRoute = [MANaviRoute naviRouteForTransit:dto.transit];
        self.type = XY_BUS;
        self.startLocation = start;
        self.endLocation = end;
        self.routeBase = dto;
    }
    
    return self;
}

-(id)initWithPath:(XYRouteBaseDto*)dto type:(XY_ROUTE_LINE_TYPE)type start:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end{
    
    if (self = [super init]){
        self.naviRoute = [MANaviRoute naviRouteForPath:dto.path withNaviType:(MANaviAnnotationType)type];
        self.type = type;
        self.startLocation = start;
        self.endLocation = end;
        self.routeBase = dto;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:true animated:true];
    self.mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:false animated:true];
}

#pragma mark - override

- (void)initializeUIElements{
    
    self.navigationItem.title = @"地图导航";
    [self shouldShowBackButton:true];
    
    self.mapView.frame = self.view.bounds;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.detailPanel];
    [self.view addSubview:self.upDownBtn];
    
    if (self.naviRoute){
        [self drawRouteLineOnMap];
        [self.detailPanel.tableView reloadData];
    }
    
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
    [locBtn addTarget:self action:@selector(moveToStart) forControlEvents:UIControlEventTouchUpInside];
    locBtn.layer.cornerRadius = 5.0f;
    locBtn.layer.masksToBounds = true;
    [self.view addSubview:locBtn];
}

#pragma mark - property

-(XYRouteDetailPanel*)detailPanel{
    if (!_detailPanel) {
        _detailPanel = [[XYRouteDetailPanel alloc]init];
        _detailPanel.frame = CGRectMake(0, self.view.bounds.size.height - [_detailPanel totalHeight], SCREEN_WIDTH, _detailPanel.totalHeight);
        _detailPanel.titleLabel.text = self.routeBase.title;
        _detailPanel.timeLabel.text = self.routeBase.time;
        _detailPanel.distanceLabel.text = self.routeBase.distance;
        _detailPanel.walkingLabel.text = self.routeBase.walkingDistance;
        _detailPanel.tableView.delegate = self;
        _detailPanel.tableView.dataSource = self;
    }
    return _detailPanel;
}

- (UIButton*)upDownBtn{
    if (!_upDownBtn) {
        _upDownBtn = [[UIButton alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 54)/2, self.detailPanel.frame.origin.y - 15, 54, 15)];
        _upDownBtn.layer.shadowOffset = CGSizeMake(0, -7);
        _upDownBtn.layer.shadowColor = LIGHT_TEXT_COLOR.CGColor;
        _upDownBtn.layer.shadowOpacity = 0.2;
        _upDownBtn.backgroundColor = WHITE_COLOR;
        _upDownBtn.layer.cornerRadius = 1.0;
        _upDownBtn.layer.masksToBounds = true;
        [_upDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [_upDownBtn addTarget:self action:@selector(upDownBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addUpDownGestureRecognizerTo:_upDownBtn];
    }
    return _upDownBtn;
}

#pragma mark - button

- (void)addUpDownGestureRecognizerTo:(UIView*)view{
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [downRecognizer setDirection: UISwipeGestureRecognizerDirectionDown];
    [view addGestureRecognizer:downRecognizer];
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [upRecognizer setDirection: UISwipeGestureRecognizerDirectionUp];
    [view addGestureRecognizer:upRecognizer];
}

- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    if ((self.detailPanel.isFolded && recognizer.direction == UISwipeGestureRecognizerDirectionUp)||((!self.detailPanel.isFolded) && recognizer.direction == UISwipeGestureRecognizerDirectionDown)){
        [self upDownBtnClicked];
    }
}

- (void)upDownBtnClicked{
    
    [UIView animateWithDuration:0.2 animations:^{
        if (self.detailPanel.isFolded){
            self.detailPanel.frame = CGRectMake(0, self.view.bounds.size.height - [self.detailPanel totalHeight], SCREEN_WIDTH, [self.detailPanel totalHeight]);
            [self.upDownBtn setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
            self.upDownBtn.frame = CGRectMake((SCREEN_WIDTH - 54)/2, self.detailPanel.frame.origin.y - 15, 54, 15);
            self.detailPanel.isFolded = false;
        }
        else{
            self.detailPanel.frame = CGRectMake(0, self.view.bounds.size.height -  [self.detailPanel foldedHeight], SCREEN_WIDTH, [self.detailPanel foldedHeight]);
            [self.upDownBtn setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
            self.upDownBtn.frame = CGRectMake((SCREEN_WIDTH - 54)/2, self.detailPanel.frame.origin.y - 15, 54, 15);
            self.detailPanel.isFolded = true;
        }
    }];
}




#pragma mark - draw

- (void)drawRouteLineOnMap{
    
    [self clearMapView];
    [self.naviRoute addToMapView:self.mapView];
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines] animated:YES];
    [self addDefaultAnnotations];
    if (self.naviRoute.naviAnnotations.count) {
        MANaviAnnotation *item = [self.naviRoute.naviAnnotations objectAtIndex:0];
        self.mapView.centerCoordinate = item.coordinate;
    }
}

- (void)addDefaultAnnotations{
    
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startLocation;
    startAnnotation.title      = @"起点";
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.endLocation;
    destinationAnnotation.title      = @"终点";
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}

-(void)clearMapView{
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}

-(void)moveToStart{
    if ([self.naviRoute.naviAnnotations count] > 0){
        MANaviAnnotation *item = [self.naviRoute.naviAnnotations objectAtIndex:0];
        self.mapView.centerCoordinate = item.coordinate;
    }
    self.mapView.showsUserLocation = true;
    [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:true];
}
     
#pragma mark - MAMapViewDelegate

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay{
    if ([overlay isKindOfClass:[MAPolyline class]]){
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:(MAPolyline*)overlay];
        polylineView.lineWidth   = 6;
        polylineView.strokeColor = THEME_COLOR;
        polylineView.lineDash = YES;
        return polylineView;
    }
    if ([overlay isKindOfClass:[MANaviPolyline class]]){
        MANaviPolyline *naviPolyline = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polylineView = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyline.polyline];
        polylineView.lineWidth = 8;
        polylineView.strokeColor = THEME_COLOR;
        return polylineView;
    }
    return nil;
}

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
        
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]]){
        static NSString *navigationCellIdentifier = @"navigationCellIdentifier";
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:navigationCellIdentifier];
        if (poiAnnotationView == nil){
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation
                                                             reuseIdentifier:navigationCellIdentifier];
        }
        poiAnnotationView.canShowCallout = YES;
        if ([annotation isKindOfClass:[MANaviAnnotation class]]){
            switch (((MANaviAnnotation*)annotation).type){
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bmk_bus"];
                    break;
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"bmk_car"];
                    break;
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"bmk_walk"];
                    break;
                default:
                    break;
            }
        }else{
            /* 起点. */
            if ([[annotation title] isEqualToString:@"起点"]){
                poiAnnotationView.image = [UIImage imageNamed:@"bmk_start"];
            }
            /* 终点. */
            else if([[annotation title] isEqualToString:@"终点"]){
                poiAnnotationView.image = [UIImage imageNamed:@"bmk_end"];
            }
            
        }
        return poiAnnotationView;
    }
    
    return nil;
}



#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.naviRoute.naviAnnotations count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = SIMPLE_TEXT_FONT;
        cell.textLabel.numberOfLines = 2;
    }
    MANaviAnnotation *item = [self.naviRoute.naviAnnotations objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    if(self.type == XY_DRIVING){
       cell.imageView.image = [UIImage imageNamed:@"icon_car"];
    }else if(self.type == XY_WAKLING){
       cell.imageView.image = [UIImage imageNamed:@"icon_walk"];
    }else{
        switch (item.type){
            case MANaviAnnotationTypeBus:
                cell.imageView.image = [UIImage imageNamed:@"icon_bus"];
                break;
            case MANaviAnnotationTypeDrive:
                cell.imageView.image = [UIImage imageNamed:@"icon_car"];
                break;
            case MANaviAnnotationTypeWalking:
                cell.imageView.image = [UIImage imageNamed:@"icon_walk"];
                break;
            default:
                break;
        }
    }
    
    return cell;
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
