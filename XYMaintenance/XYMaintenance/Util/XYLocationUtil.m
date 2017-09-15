//
//  LocationUtil.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/15.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYLocationUtil.h"
#import "XYConfig.h"
#import <CoreLocation/CoreLocation.h>

@interface XYLocationUtil ()<CLLocationManagerDelegate>
{
    CLLocationManager* _locationManager;
}
@end

@implementation XYLocationUtil

+(XYLocationUtil*)sharedInstance
{
    static dispatch_once_t onceToken;
    static XYLocationUtil *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYLocationUtil alloc] init];
    });
    return sharedInstance;
}

#pragma mark - start/stop location

-(void)startLocating
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    
    if ([CLLocationManager locationServicesEnabled])
    {
        if (IS_IOS_8_LATER)
        {
            [_locationManager requestAlwaysAuthorization];
            
            if (![CLLocationManager significantLocationChangeMonitoringAvailable])
            {
                [self doWhenBackgroundLocationDisabled];
                return;
            }
            
            if (IS_IOS_9_LATER)
            {
                //_locationManager.allowsBackgroundLocationUpdates = YES; //适配9，细节待定
            }
        }
        
    }
    else
    {
        [self doWhenLocationServiceDisabled];
        return;
    }

    [_locationManager startMonitoringSignificantLocationChanges];
}

-(void)stopLocating
{
    [_locationManager stopUpdatingLocation];
}

-(void)startBackgroundLocating
{
    [_locationManager startMonitoringSignificantLocationChanges];
}

#pragma mark - show alerts

-(void)doWhenLocationServiceDisabled
{
   //提示定位功能未打开
    NSLog(@"定位weidakai");
}

-(void)doWhenBackgroundLocationDisabled
{
   //提示后台定位未打开
    NSLog(@"后台定位weidakai");
}


#pragma mark - location delegate

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status)
    {
        case kCLAuthorizationStatusAuthorized:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            [self doWhenBackgroundLocationDisabled];
        case kCLAuthorizationStatusNotDetermined:
            if(IS_IOS_8_LATER)
            {
                [manager requestAlwaysAuthorization];
                if (IS_IOS_9_LATER)
                {
                    //_locationManager.allowsBackgroundLocationUpdates = YES; //适配9，细节待定
                }
            }
        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
//    CLLocation *location=[locations firstObject];//取出第一个位置
//    CLLocationCoordinate2D coordinate=location.coordinate;//位置坐标
    //TBD
    
    NSLog(@"location updated %@",locations);
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //定位失败 TBD
}

@end
