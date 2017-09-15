//
//  AMapXYUtility.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>

@interface CommonUtility : NSObject

//+ (CLLocationCoordinate2D *)coordinatesForString:(NSString *)string
//                                 coordinateCount:(NSUInteger *)coordinateCount
//                                      parseToken:(NSString *)token;
//
+ (MAPolyline *)polylineForCoordinateString:(NSString *)coordinateString;

+ (MAMapRect)mapRectForOverlays:(NSArray *)overlays;
//
//+ (MAPolyline *)polylineForStep:(AMapStep *)step;
//
//+ (MAPolyline *)polylineForBusLine:(AMapBusLine *)busLine;
//
//+ (NSArray *)polylinesForWalking:(AMapWalking *)walking;
//
//+ (NSArray *)polylinesForSegment:(AMapSegment *)segment;
//
//+ (NSArray *)polylinesForPath:(AMapPath *)path;
//
//+ (NSArray *)polylinesForTransit:(AMapTransit *)transit;
//
//
//+ (MAMapRect)unionMapRect1:(MAMapRect)mapRect1 mapRect2:(MAMapRect)mapRect2;
//
//+ (MAMapRect)mapRectUnion:(MAMapRect *)mapRects count:(NSUInteger)count;
//

//
//
//+ (MAMapRect)minMapRectForMapPoints:(MAMapPoint *)mapPoints count:(NSUInteger)count;
//
+ (MAMapRect)minMapRectForAnnotations:(NSArray *)annotations;

@end

