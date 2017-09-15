//
//  XYASelectMapLocViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/10.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@protocol XYASelectMapLocationDelegate <NSObject>

-(void)onLocationSelected:(NSString*)locationName coordinate:(CLLocationCoordinate2D)coordinate;

@end

@interface XYASelectMapLocViewController : XYBaseViewController

@property(assign,nonatomic) id<XYASelectMapLocationDelegate> delegate;
@property (nonatomic, weak) MAMapView *mapView;
@property (nonatomic, weak) AMapSearchAPI *search;
@end
