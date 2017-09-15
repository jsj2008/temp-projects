//
//  XYLocationManagerBackground.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface XYLocationManagerBackground : CLLocationManager
+ (instancetype)sharedManager;
@end
