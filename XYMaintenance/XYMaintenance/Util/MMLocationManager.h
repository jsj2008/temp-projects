//
//  MMLocationManager.h
//  DemoBackgroundLocationUpdate
//
//  Created by Ralph Li on 7/20/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MMLocationManager : CLLocationManager

+ (instancetype)sharedManager;

@property (nonatomic, assign) CGFloat minSpeed;
@property (nonatomic, assign) CGFloat minFilter;
@property (nonatomic, assign) CGFloat minInteval;

@end
