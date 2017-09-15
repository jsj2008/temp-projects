//
//  XYASearchRouteViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface XYASearchRouteViewController : XYBaseViewController
@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, weak) AMapSearchAPI *search;
-(id)initWithTargetAddress:(NSString*)tAddress targetLocation:(CLLocationCoordinate2D)tLocation myLocation:(CLLocationCoordinate2D)mLocation city:(NSString*)area;
@end
