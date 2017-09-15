//
//  XYARouteDetailViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>



@interface XYARouteDetailViewController : XYBaseViewController

@property(assign,nonatomic)MAMapView* mapView;

-(id)initWithTransit:(XYRouteBaseDto*)dto start:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end;

-(id)initWithPath:(XYRouteBaseDto*)dto type:(XY_ROUTE_LINE_TYPE)type start:(CLLocationCoordinate2D)start end:(CLLocationCoordinate2D)end;

@end
