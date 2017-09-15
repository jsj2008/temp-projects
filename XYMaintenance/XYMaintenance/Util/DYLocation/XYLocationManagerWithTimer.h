//
//  XYLocationWithTimer.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>

//CLLocationDistance distance = MAMetersBetweenMapPoints(point1,point2); 两点的高德距离lalala

@interface XYLocationManagerWithTimer : NSObject<AMapLocationManagerDelegate>

@property(strong,nonatomic) AMapLocationManager *locationManager;
@property(strong,nonatomic) NSTimer* uploadTimer;
@property(assign,nonatomic) CLLocationCoordinate2D myLastLocation;
@property(strong,nonatomic) NSString* myLastAddress;
////test
//@property (strong, nonatomic) NSFileManager          * fileManager;
//@property (strong, nonatomic) NSString               * filePath;

+ (instancetype)sharedManager;
- (void)updateLocation;
- (BOOL)isReasonableLocation:(CLLocationCoordinate2D)location;
@end
