//
//  XYAmapDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    XY_UNKNOWN                    = -1,
    XY_BUS                       = 0,///公交
    XY_DRIVING                  = 2,///驾车
    XY_WAKLING                 = 1,///步行
}XY_ROUTE_LINE_TYPE;


@interface XYAmapLocationDto : NSObject
@property(assign,nonatomic)NSInteger status;
@property(copy,nonatomic)NSString* info;
@property(copy,nonatomic)NSString* locations;
@end

@class AMapTransit;
@class AMapPath;
@class AMapRoute;

@interface XYRouteBaseDto : NSObject

@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* distance;
@property(copy,nonatomic)NSString* time;
@property(copy,nonatomic)NSString* walkingDistance;
@property(retain,nonatomic)AMapTransit* transit;
@property(retain,nonatomic)AMapPath* path;
@property(assign,nonatomic)double startLatitude;
@property(assign,nonatomic)double startLongtitude;
@property(assign,nonatomic)int type;

+ (NSArray*)routeBaseArrayFromRouteLines:(AMapRoute*)route type:(XY_ROUTE_LINE_TYPE)type;

@end
