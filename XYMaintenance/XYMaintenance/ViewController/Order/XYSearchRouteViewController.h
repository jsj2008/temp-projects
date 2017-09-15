//
//  XYSearchRouteViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface XYSearchRouteViewController : XYBaseViewController

-(id)initWithTargetLocation:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate;

@end
