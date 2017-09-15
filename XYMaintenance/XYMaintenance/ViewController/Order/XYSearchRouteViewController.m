//
//  XYSearchRouteViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSearchRouteViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "XYRouteCell.h"
#import "XYSelectMapLocationViewController.h"
#import "XYRouteDetailViewController.h"

typedef enum
{
    XY_BUS                       = 0,///公交
    XY_DRIVING                  = 1,///驾车
    XY_WAKLING                 = 2,///步行
}XY_ROUTE_LINE_TYPE;


@interface XYSearchRouteViewController ()<XYSelectMapLocationDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate,BMKRouteSearchDelegate,BMKLocationServiceDelegate>
{
    UITableView* _tableView;
    UISegmentedControl* _segmentControl;
    UIActionSheet* _actionSheet;
    
    NSString* _startAddress;
    CLLocationCoordinate2D _startCoordinate;
    NSString* _targetAddress;
    CLLocationCoordinate2D _targetCoordinate;
    
    BOOL _hasUpdatedUserLocation;
    NSMutableDictionary* _routeCacheDictionary;
    BMKRouteSearch* _routeSearch;
    BMKLocationService* _locService;
    
    XYSelectMapLocationViewController* _selectMapViewController;
}
@end

@implementation XYSearchRouteViewController

-(id)initWithTargetLocation:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        _targetAddress = address;
        _targetCoordinate = coordinate;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _selectMapViewController = nil;
    _actionSheet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _routeSearch.delegate = self;
    _locService.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated
{
     [super viewWillDisappear:animated];
     _routeSearch.delegate = nil;
     _locService.delegate = nil;
}

#pragma mark - override

- (void)initializeData
{
    _routeCacheDictionary = [[NSMutableDictionary alloc]init];
    [_routeCacheDictionary setObject:@[] forKey:@(XY_BUS)];
    [_routeCacheDictionary setObject:@[] forKey:@(XY_DRIVING)];
    [_routeCacheDictionary setObject:@[] forKey:@(XY_WAKLING)];
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _hasUpdatedUserLocation = false;
}

- (void)initializeUIElements
{
    self.navigationItem.title = @"查看路线";
    [self shouldShowBackButton:true];
    _segmentControl = [[UISegmentedControl alloc]initWithItems:@[@"公交",@"驾车",@"步行"]];
    _segmentControl.frame = CGRectMake(20, 5, ScreenWidth - 2 * 20, 30);
    _segmentControl.backgroundColor = WHITE_COLOR;
    _segmentControl.tintColor = THEME_COLOR;
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(onSegmentSelected:) forControlEvents:UIControlEventValueChanged];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height)];
    _tableView.backgroundColor = BACKGROUND_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setTableHeaderView:[TableViewUtil getSingleLine]];
    [_tableView setTableFooterView:[TableViewUtil getSingleLine]];
    [self.view addSubview:_tableView];
    
    [self startLocating];
}


#pragma mark - 按钮逻辑

- (void)onSegmentSelected:(id)sender
{
    if ([[self getArrayFromCacheWithIndex:_segmentControl.selectedSegmentIndex] count] > 0)
    {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        [self searchForRouteLines];
    }
}

- (void)showActionSheet
{
    if (_actionSheet == nil)
    {
        _actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"我的位置",@"地图选点",nil];
    }
    
    [_actionSheet showFromTabBar:self.tabBarController.tabBar];
}

-(void)resetCacheAndGetNewRoute
{
    [_routeCacheDictionary setObject:@[] forKey:@(XY_BUS)];
    [_routeCacheDictionary setObject:@[] forKey:@(XY_DRIVING)];
    [_routeCacheDictionary setObject:@[] forKey:@(XY_WAKLING)];
    [self searchForRouteLines];
}

-(NSArray*)getArrayFromCacheWithIndex:(NSInteger)index
{
    return [_routeCacheDictionary objectForKey:@(index)];
}

-(void)searchForRouteLines
{
  if (_routeSearch == nil)
    {
        _routeSearch = [[BMKRouteSearch alloc]init];
        _routeSearch.delegate = self;
    }
    
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            [self searchForBusLines];
            break;
        case 1:
            [self searchForDrivingLines];
            break;
        case 2:
            [self searchForWalkingLines];
            break;
        default:
            break;
    }
}

-(void)searchForBusLines
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.pt =_startCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.pt = _targetCoordinate;

    BMKTransitRoutePlanOption *transitRouteSearchOption = [[BMKTransitRoutePlanOption alloc]init];
    transitRouteSearchOption.city = @"上海市";
    transitRouteSearchOption.from = start;
    transitRouteSearchOption.to = end;
    BOOL flag = [_routeSearch transitSearch:transitRouteSearchOption];
    if(flag)
    {
        NSLog(@"bus检索发送成功");
    }
    else
    {
        NSLog(@"bus检索发送失败");
    }
}

-(void)searchForDrivingLines
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.cityName = @"上海市";
    start.pt = _startCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = @"上海市";
    end.pt = _targetCoordinate;
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = start;
    drivingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch drivingSearch:drivingRouteSearchOption];
    if(flag)
    {
        NSLog(@"car检索发送成功");
    }
    else
    {
        NSLog(@"car检索发送失败");
    }
}

-(void)searchForWalkingLines
{
    BMKPlanNode* start = [[BMKPlanNode alloc]init];
    start.cityName = @"上海市";
    start.pt = _startCoordinate;
    BMKPlanNode* end = [[BMKPlanNode alloc]init];
    end.cityName = @"上海市";
    end.pt = _targetCoordinate;
    
    BMKWalkingRoutePlanOption *walkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    walkingRouteSearchOption.from = start;
    walkingRouteSearchOption.to = end;
    BOOL flag = [_routeSearch walkingSearch:walkingRouteSearchOption];
    if(flag)
    {
        NSLog(@"walk检索发送成功");
    }
    else
    {
        NSLog(@"walk检索发送失败");
    }
}

#pragma mark - locationService

-(void)startLocating
{
    [self showLoadingMask];
    NSLog(@"showLoadingMask");
    _locService.delegate = self;
    _hasUpdatedUserLocation = false;
    [_locService startUserLocationService];
}

-(void)mapSelectionstartLocating
{
    _locService.delegate = self;
    _hasUpdatedUserLocation = false;
    [_locService startUserLocationService];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
     NSLog(@"didUpdateBMKUserLocation %f,%f",userLocation.location.coordinate.longitude,userLocation.location.coordinate.latitude);
    
    [self hideLoadingMask];
    
    if (_hasUpdatedUserLocation)
    {
        return;
    }
    
    _hasUpdatedUserLocation = true;
    [_locService stopUserLocationService];
    _startCoordinate = userLocation.location.coordinate;
    _startAddress = @"我的位置";
   
    [_tableView reloadData];
    

    if (_selectMapViewController)
    {
       [_selectMapViewController setCurrentLocationOnMap:userLocation];
    }
    
    [self resetCacheAndGetNewRoute];
}

- (void)didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"didFailToLocateUserWithError %@",error.localizedDescription);
    
    [self hideLoadingMask];
    
    _hasUpdatedUserLocation = true;
    [_locService stopUserLocationService];
    [self showToast:error.localizedDescription];
    
    if (_selectMapViewController)
    {
        [_selectMapViewController showLocatingFailure:error.localizedDescription];
    }
}

-(void)onLocationSelected:(NSString*)locationName coordinate:(CLLocationCoordinate2D)coordinate
{
    _routeSearch.delegate = self;
    _locService.delegate = self;
    
    _startCoordinate = coordinate;
    _startAddress = locationName ? locationName : @"";
    
    [self.navigationController popViewControllerAnimated:true];

    [_tableView reloadData];
    
    [self resetCacheAndGetNewRoute];
}


#pragma mark - actionsheet

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self startLocating];
    }
    else if (buttonIndex == 1)
    {
        if (_selectMapViewController == nil)
        {
            _selectMapViewController = [[XYSelectMapLocationViewController alloc]init];
            _selectMapViewController.delegate = self;
        }
        
        [self.navigationController pushViewController:_selectMapViewController animated:true];
    }
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
        case 1:
            return [[self getArrayFromCacheWithIndex:_segmentControl.selectedSegmentIndex] count];
        default:
            return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
       XYRouteCell* cell = [tableView dequeueReusableCellWithIdentifier:[XYRouteCell defaultReuseId]];
    
       if (cell == nil)
       {
           cell = [[[NSBundle mainBundle]loadNibNamed:[XYRouteCell defaultReuseId] owner:self options:nil]lastObject];
       }
    
       [cell setData:[[self getArrayFromCacheWithIndex:_segmentControl.selectedSegmentIndex] objectAtIndex:indexPath.row] index:indexPath.row];
    
       return cell;
    }
    else
    {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        
        if (indexPath.row == 0)
        {
            cell.textLabel.text = _startAddress;
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = _targetAddress;
        }

        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 44;
    }
    
    return [XYRouteCell defaultHeight];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        UIView* segmentHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, _segmentControl.frame.size.height + 10)];
        [segmentHeaderView addSubview:_segmentControl];
        return segmentHeaderView;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return _segmentControl.frame.size.height + 10;
    }
    
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        [self showActionSheet];
    }
    else if(indexPath.section == 1)
    {
        XYRouteBaseDto* dto = [[self getArrayFromCacheWithIndex:_segmentControl.selectedSegmentIndex]objectAtIndex:indexPath.row];
        XYRouteDetailViewController* routeDetailViewController = [[XYRouteDetailViewController alloc]initWithRouteLine:dto.routeLine type:_segmentControl.selectedSegmentIndex];
        [self.navigationController pushViewController:routeDetailViewController animated:true];
    }
}

#pragma mark - route search

- (void)onGetTransitRouteResult:(BMKRouteSearch*)searcher result:(BMKTransitRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [_routeCacheDictionary setObject:[self routeBaseArrayFromRouteLines:result.routes type:XY_BUS] forKey:@(XY_BUS)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [_routeCacheDictionary setObject:@[] forKey:@(XY_BUS)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher result:(BMKDrivingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [_routeCacheDictionary setObject:[self routeBaseArrayFromRouteLines:result.routes type:XY_DRIVING] forKey:@(XY_DRIVING)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [_routeCacheDictionary setObject:@[] forKey:@(XY_DRIVING)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error
{
    
    if (error == BMK_SEARCH_NO_ERROR)
    {
        [_routeCacheDictionary setObject:[self routeBaseArrayFromRouteLines:result.routes type:XY_WAKLING] forKey:@(XY_WAKLING)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
    else
    {
        [_routeCacheDictionary setObject:@[] forKey:@(XY_WAKLING)];
        [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
    }
}

#pragma mark - route data transformer

-(NSArray*)routeBaseArrayFromRouteLines:(NSArray*)array type:(XY_ROUTE_LINE_TYPE)type
{
    NSMutableArray* routeBaseArray = [[NSMutableArray alloc]init];
    
    for (NSInteger i = 0; i < [array count]; i ++)
    {
        BMKRouteLine* route = [array objectAtIndex:i];
        
        XYRouteBaseDto* dto = [self routeBaseFromLine:route type:type];
        
        if (dto)
        {
            [routeBaseArray addObject:dto];
        }
    }
    
    return routeBaseArray;
}

-(XYRouteBaseDto*)routeBaseFromLine:(BMKRouteLine*)route type:(XY_ROUTE_LINE_TYPE)type
{
    if (route == nil)
    {
        return nil;
    }
    
    XYRouteBaseDto* dto = [[XYRouteBaseDto alloc]init];
    
    if (type == XY_BUS)
    {
        BMKTransitRouteLine* routeLine = (BMKTransitRouteLine*)route;
        
        NSInteger walkingDistance = 0;
        NSMutableString* transitTitle = [[NSMutableString alloc]initWithString:@""];
        
        for (NSInteger i = 0; i < [routeLine.steps count]; i ++)
        {
            BMKTransitStep* step = [routeLine.steps objectAtIndex:i];
            
            if (step.stepType == BMK_WAKLING)
            {
                walkingDistance += step.distance;
            }
            else
            {
                if (![transitTitle isEqual:@""])
                {
                    [transitTitle appendString:@"->"];
                }
                [transitTitle appendString:step.vehicleInfo.title];
            }
        }
        
        dto.title = transitTitle;
        dto.walkingDistance = [NSString stringWithFormat:@"步行%ld米",(long)walkingDistance];
    }
    else if (type == XY_DRIVING)
    {
        BMKDrivingRouteLine* routeLine = (BMKDrivingRouteLine*)route;
        
        if ([routeLine.wayPoints count]==0)
        {
            dto.title = @"驾车路线";
        }
        else
        {
            NSMutableString* drivingTitle = [[NSMutableString alloc]initWithString:@"途径"];
            if ([routeLine.wayPoints count]>0) {
                BMKPlanNode* startNode = [routeLine.wayPoints objectAtIndex:0];
                [drivingTitle appendString:startNode.name];
            }
            if([routeLine.wayPoints count]>1)
            {
                [drivingTitle appendString:@"和"];
                BMKPlanNode* endNode = [routeLine.wayPoints objectAtIndex:[routeLine.wayPoints count]-1];
                [drivingTitle appendString:endNode.name];
            }
            
            dto.title = drivingTitle;
        }
        
        dto.walkingDistance = @"";
    }
    else if (type == XY_WAKLING)
    {
        dto.title = @"步行路线";
        dto.walkingDistance = @"";
    }
   
    if (route.distance < 1000)
    {
        dto.distance = [NSString stringWithFormat:@"%d米",route.distance];
    }
    else
    {
        dto.distance = [NSString stringWithFormat:@"%.1f公里",route.distance/1000.0];
    }
    
    
    NSMutableString* timeString = [[NSMutableString alloc]init];
    if (route.duration.dates>0)
    {
        [timeString appendFormat:@"%d天",route.duration.dates];
    }
    if (route.duration.hours>0)
    {
        [timeString appendFormat:@"%d小时",route.duration.hours];
    }
    if (route.duration.minutes>0)
    {
        [timeString appendFormat:@"%d分钟",route.duration.minutes];
    }
    dto.time = timeString;
    
    dto.routeLine = route;
    
    return dto;
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
