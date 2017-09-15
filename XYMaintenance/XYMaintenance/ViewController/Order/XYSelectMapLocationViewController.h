//
//  XYSelectMapLocationViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <CoreLocation/CoreLocation.h>

@protocol XYSelectMapLocationDelegate <NSObject>

@required
-(void)mapSelectionstartLocating;

@optional
-(void)onLocationSelected:(NSString*)locationName coordinate:(CLLocationCoordinate2D)coordinate;

@end


@class BMKUserLocation;

@interface XYSelectMapLocationViewController : XYBaseViewController

@property(assign,nonatomic) id<XYSelectMapLocationDelegate> delegate;

-(void)setCurrentLocationOnMap:(BMKUserLocation*)location;

-(void)showLocatingFailure:(NSString*)errorString;

@end
