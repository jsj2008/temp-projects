//
//  XYAMapManager.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/14.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface XYAMapManager : NSObject<MAMapViewDelegate>

@property(strong,nonatomic)MAMapView* aMapView;
@property(strong,nonatomic)AMapSearchAPI* aMapSearchAPI;

//+(instancetype)sharedInstance;
//-(void)clearMapView;

@end
