//
//  XYRouteDetailViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRouteDetailViewController.h"

typedef NS_ENUM(NSInteger, XYBMKRouteAnnotationType)
{
    XYBMKRouteAnnotationTypeStarting = 0,
    XYBMKRouteAnnotationTypeEnding,
    XYBMKRouteAnnotationTypeBus,
    XYBMKRouteAnnotationTypeSubway,
    XYBMKRouteAnnotationTypeDriving,
    XYBMKRouteAnnotationTypePassingBy,
};

@interface XYRouteAnnotation : BMKPointAnnotation

@property (assign,nonatomic) XYBMKRouteAnnotationType type; //0:起点 1：终点 2：公交 3：地铁 4:驾乘 5:途经点
@property (assign,nonatomic) NSInteger degree;
@end

@implementation XYRouteAnnotation
@end

@interface UIImage(InternalMethod)

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end

@implementation UIImage(InternalMethod)
- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees
{
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@interface XYRouteDetailViewController ()<BMKMapViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    BMKMapView* _mapView;
    UITableView* _stepsTableView;
    NSArray* _instructionArray;
}
@property(retain,nonatomic)BMKRouteLine* currentLine;
@property(assign,nonatomic)XYBMKRouteSearchType currentType;
@end

@implementation XYRouteDetailViewController

-(id)initWithRouteLine:(BMKRouteLine*)plan type:(XYBMKRouteSearchType)type
{
    if (self = [super init])
    {
        _currentLine = plan;
        _currentType = type;
        
        _instructionArray = [[NSArray alloc]init];
    }

    return self;
}

-(void)setRouteLine:(BMKRouteLine*)plan type:(XYBMKRouteSearchType)type
{
    _currentLine = plan;
    _currentType = type;
    
    if (_currentLine && _mapView && _stepsTableView)
    {
        [self drawRouteLineOnMap];
        [_stepsTableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
     _mapView.delegate = nil;
}


#pragma mark - override

- (void)initializeUIElements
{
    self.navigationItem.title = @"地图导航";
    [self shouldShowBackButton:true];
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    _stepsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _mapView.frame.size.height + _mapView.frame.origin.y , ScreenWidth, self.view.bounds.size.height - (_mapView.frame.size.height + _mapView.frame.origin.y))];
    _stepsTableView.backgroundColor = BACKGROUND_COLOR;
    _stepsTableView.delegate = self;
    _stepsTableView.dataSource = self;
    [_stepsTableView setTableFooterView:[TableViewUtil getSingleLine]];
    [_stepsTableView setTableHeaderView:[TableViewUtil getSingleLine]];
    [self.view addSubview:_stepsTableView];
    
    if (self.currentLine)
    {
        [self drawRouteLineOnMap];
        [_stepsTableView reloadData];
    }
    
}

#pragma mark - mapview delegate

- (BMKAnnotationView*)getRouteAnnotationView:(BMKMapView *)mapview viewForAnnotation:(XYRouteAnnotation*)routeAnnotation
{
    BMKAnnotationView* view = nil;
    switch (routeAnnotation.type) {
        case XYBMKRouteAnnotationTypeStarting:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"start_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"start_node"];
                view.image = [UIImage imageNamed:@"bmk_start"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case XYBMKRouteAnnotationTypeEnding:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"end_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"end_node"];
                view.image = [UIImage imageNamed:@"bmk_end"];
                view.centerOffset = CGPointMake(0, -(view.frame.size.height * 0.5));
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case XYBMKRouteAnnotationTypeBus:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"bus_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"bus_node"];
                view.image = [UIImage imageNamed:@"bmk_bus"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case XYBMKRouteAnnotationTypeSubway:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"rail_node"];
            if (view == nil)
            {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"rail_node"];
                view.image = [UIImage imageNamed:@"bmk_rail"];
                view.canShowCallout = TRUE;
            }
            view.annotation = routeAnnotation;
        }
            break;
        case XYBMKRouteAnnotationTypeDriving:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"route_node"];
            if (view == nil){
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"route_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            UIImage* image = [UIImage imageNamed:@"bmk_direction"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        case XYBMKRouteAnnotationTypePassingBy:
        {
            view = [mapview dequeueReusableAnnotationViewWithIdentifier:@"waypoint_node"];
            if (view == nil) {
                view = [[BMKAnnotationView alloc]initWithAnnotation:routeAnnotation reuseIdentifier:@"waypoint_node"];
                view.canShowCallout = TRUE;
            } else {
                [view setNeedsDisplay];
            }
            
            UIImage* image = [UIImage imageNamed:@"bmk_waypoint"];
            view.image = [image imageRotatedByDegrees:routeAnnotation.degree];
            view.annotation = routeAnnotation;
        }
            break;
        default:
            break;
    }
    return view;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)view viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[XYRouteAnnotation class]]) {
        return [self getRouteAnnotationView:view viewForAnnotation:(XYRouteAnnotation*)annotation];
    }
    return nil;
}

- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
       // polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        polylineView.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}

#pragma mark - draw on baidu map

-(void)drawRouteLineOnMap
{
    switch (_currentType)
    {
        case XYBMKRouteLineTypeBus:
            [self drawBusLine];
            break;
        case XYBMKRouteLineTypeDriving:
            [self drawDrivingLine];
            break;
        case XYBMKRouteLineTypeWalking:
            [self drawWalkingLine];
            break;
        default:
            break;
    }
}

-(void)drawBusLine
{
    BMKTransitRouteLine* plan = (BMKTransitRouteLine*)self.currentLine;
    NSInteger size = [plan.steps count];
    NSInteger planPointCounts = 0;
    for (NSInteger i = 0; i < size; i++)
    {
        BMKTransitStep* transitStep = [plan.steps objectAtIndex:i];
        
        if(i==0)
        {
            [self addStartingAnnotation:plan.starting.location];
        }
        else if(i==size-1)
        {
            [self addEndingAnnotation:plan.terminal.location];
        }
        else
        {
            XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.instruction;
            item.type = XYBMKRouteAnnotationTypeSubway;
            [_mapView addAnnotation:item];
            item = nil;
        }
        
        planPointCounts += transitStep.pointsCount;
    }
    
    _instructionArray = [_mapView.annotations copy];
    [self createPolyLineWithPlan:plan count:planPointCounts];
    
    [self showUserLocationRegionWithLocation:plan.starting.location];
}

-(void)drawDrivingLine
{
    BMKDrivingRouteLine* plan = (BMKDrivingRouteLine*)self.currentLine;
    NSInteger size = [plan.steps count];
    NSInteger planPointCounts = 0;
    for (NSInteger i = 0; i < size; i++)
    {
        BMKDrivingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0)
        {
            [self addStartingAnnotation:plan.starting.location];
        }
        else if(i==size-1)
        {
            [self addEndingAnnotation:plan.terminal.location];
        }
        else{
        
            XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
            item.coordinate = transitStep.entrace.location;
            item.title = transitStep.entraceInstruction;
            item.degree = transitStep.direction * 30;
            item.type = XYBMKRouteAnnotationTypeDriving;
            [_mapView addAnnotation:item];
            item = nil;
        }
        
        planPointCounts += transitStep.pointsCount;
    }
    
    if (plan.wayPoints)
    {
        for (BMKPlanNode* tempNode in plan.wayPoints) {
            XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
            item = [[XYRouteAnnotation alloc]init];
            item.coordinate = tempNode.pt;
            item.type = XYBMKRouteAnnotationTypePassingBy;
            item.title = tempNode.name;
            [_mapView addAnnotation:item];
            item = nil;
        }
    }
    
    _instructionArray = [_mapView.annotations copy];
    [self createPolyLineWithPlan:plan count:planPointCounts];
    
    [self showUserLocationRegionWithLocation:plan.starting.location];
}

-(void)drawWalkingLine
{
    BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)self.currentLine;
    NSInteger size = [plan.steps count];
    NSInteger planPointCounts = 0;
    for (int i = 0; i < size; i++)
    {
        BMKWalkingStep* transitStep = [plan.steps objectAtIndex:i];
        if(i==0)
        {
            [self addStartingAnnotation:plan.starting.location];
        }
        else if(i==size-1)
        {
            [self addEndingAnnotation:plan.terminal.location];
        }
        else
        {
           XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
           item.coordinate = transitStep.entrace.location;
           item.title = transitStep.entraceInstruction;
           item.degree = transitStep.direction * 30;
           item.type = XYBMKRouteAnnotationTypeDriving;
           [_mapView addAnnotation:item];
           item = nil;
        }
        planPointCounts += transitStep.pointsCount;
    }
    
    _instructionArray = [_mapView.annotations copy];
    [self createPolyLineWithPlan:plan count:planPointCounts];
    
    [self showUserLocationRegionWithLocation:plan.starting.location];
}

- (void)clearMapViewAnnotations
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
}

- (void)addStartingAnnotation:(CLLocationCoordinate2D)location
{
    XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
    item.coordinate = location;
    item.title = @"起点";
    item.type = XYBMKRouteAnnotationTypeStarting;
    [_mapView addAnnotation:item];
    item = nil;
}

- (void)addEndingAnnotation:(CLLocationCoordinate2D)location
{
    XYRouteAnnotation* item = [[XYRouteAnnotation alloc]init];
    item.coordinate = location;
    item.title = @"终点";
    item.type = XYBMKRouteAnnotationTypeEnding;
    [_mapView addAnnotation:item];
    item = nil;
}

-(void)createPolyLineWithPlan:(BMKRouteLine*)plan count:(NSInteger)planPointCounts
{
    BMKMapPoint* temppoints = new BMKMapPoint[planPointCounts];
    NSInteger i = 0;
    for (NSInteger j = 0; j < [plan.steps count]; j++)
    {
        BMKRouteStep* transitStep = [plan.steps objectAtIndex:j];
        NSInteger k=0;
        for(k=0;k<transitStep.pointsCount;k++)
        {
            temppoints[i].x = transitStep.points[k].x;
            temppoints[i].y = transitStep.points[k].y;
            i++;
        }
    }
    
    BMKPolyline* polyLine = [BMKPolyline polylineWithPoints:temppoints count:planPointCounts];
    [_mapView addOverlay:polyLine];
    delete []temppoints;
}

#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_instructionArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = CELL_DETAIL_TEXT_FONT;
        cell.textLabel.numberOfLines = 2;
    }
    
    XYRouteAnnotation *item = [_instructionArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    
    return cell;
}

-(void)showUserLocationRegionWithLocation:(CLLocationCoordinate2D)coords
{
    BMKCoordinateRegion region;
    region.center = coords;
    region.span.latitudeDelta = 0.007;
    region.span.longitudeDelta = 0.007;
    [_mapView setRegion:region];
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
