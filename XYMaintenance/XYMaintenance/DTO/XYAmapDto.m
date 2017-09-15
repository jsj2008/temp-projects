//
//  XYAmapDto.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAmapDto.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
#import "XYStringUtil.h"

@implementation XYAmapLocationDto
@end


@implementation XYRouteBaseDto

+ (NSArray*)routeBaseArrayFromRouteLines:(AMapRoute*)route type:(XY_ROUTE_LINE_TYPE)type{
    NSMutableArray* routeBaseArray = [[NSMutableArray alloc]init];
    if (type == XY_BUS){
        for (NSInteger i = 0; i < [route.transits count]; i ++){
            AMapTransit* transit = [route.transits objectAtIndex:i];
            XYRouteBaseDto* dto = [XYRouteBaseDto routeBaseFromATransit:transit];
            if (dto){
                dto.startLatitude = route.origin.latitude;
                dto.startLongtitude = route.origin.longitude;
                [routeBaseArray addObject:dto];
            }
        }
    }else{
        for (NSInteger i = 0; i < [route.paths count]; i ++){
            AMapPath* path = [route.paths objectAtIndex:i];
            XYRouteBaseDto* dto = [XYRouteBaseDto routeBaseFromAPath:path type:type];
            if (dto){
                dto.startLatitude = route.origin.latitude;
                dto.startLongtitude = route.origin.longitude;
                [routeBaseArray addObject:dto];
            }
        }
    }
    
    return routeBaseArray;
}

+ (XYRouteBaseDto*)routeBaseFromAPath:(AMapPath*)path type:(XY_ROUTE_LINE_TYPE)type{
    if (!path) {
        return nil;
    }
    
    XYRouteBaseDto* dto = [[XYRouteBaseDto alloc]init];
    if ([path.steps count]==0){
        if (type == XY_DRIVING){
            dto.title = @"驾车路线";
        }else if (type == XY_WAKLING){
            dto.title = @"步行路线";
        }else{
            dto.title = @"导航路线";
        }
    }else{
        NSMutableString* pathTitle = [[NSMutableString alloc]initWithString:@""];
        NSInteger stepsAdded = 0;
        for (NSInteger i = 0; i < [path.steps count]; i ++){
            AMapStep* step = [path.steps objectAtIndex:i];
            if (![XYStringUtil isNullOrEmpty:step.road]){
                if (stepsAdded==0){
                    [pathTitle appendString:@"途径"];
                }else if (stepsAdded > 0){
                    [pathTitle appendString:@"和"];
                }
                [pathTitle appendString:step.road];
                stepsAdded++;
            }
            if (stepsAdded > 1){
                break;
            }
        }
        dto.title = pathTitle;
    }
    
    dto.distance = [XYRouteBaseDto getStringFromDistance:path.distance];
    dto.time = [XYRouteBaseDto getStringFromDuration:path.duration];
    dto.walkingDistance = @"";
    dto.path = path;
    dto.transit = nil;
    dto.type =type;
    
    return dto;
}

+ (XYRouteBaseDto*)routeBaseFromATransit:(AMapTransit*)transit{
    if (transit == nil) {
        return nil;
    }
    XYRouteBaseDto* dto = [[XYRouteBaseDto alloc]init];
    NSInteger totalDistance = 0;
    NSMutableString* transitTitle = [[NSMutableString alloc]initWithString:@""];
    for (NSInteger i = 0; i < [transit.segments count]; i ++ ){
        AMapSegment* seg = [transit.segments objectAtIndex:i];
        if (seg.buslines!=nil && seg.buslines.count > 0){
            if (![transitTitle isEqual:@""]){
                [transitTitle appendString:@"->"];
            }
            AMapBusLine* busline = seg.buslines[0];
            NSRange rangeOfDetail = [busline.name rangeOfString:@"("];
            if (rangeOfDetail.location!= NSNotFound){
                [transitTitle appendString:[busline.name substringToIndex:rangeOfDetail.location]];
            }else{
                [transitTitle appendString:busline.name];
            }
            totalDistance += busline.distance;
        }else if(seg.walking!=nil){
            totalDistance += seg.walking.distance;
        }
    }
    dto.title = transitTitle;
    dto.distance = [XYRouteBaseDto getStringFromDistance:totalDistance];
    dto.time = [XYRouteBaseDto getStringFromDuration:transit.duration];
    dto.walkingDistance = [XYRouteBaseDto getStringFromDistance:transit.walkingDistance];
    dto.path = nil;
    dto.transit = transit;
    dto.type = XY_BUS;
    return dto;
}

+ (NSString*)getStringFromDistance:(NSInteger)distance{
    if (distance < 1000){
        return [NSString stringWithFormat:@"%ld米",(long)distance];
    }else{
        return [NSString stringWithFormat:@"%.1f公里",distance/1000.0];
    }
}

+ (NSString*)getStringFromDuration:(NSInteger)duration{
    if (duration < 60){
        return @"<1分钟";
    }else if(duration < 60 * 60){
        NSInteger minutes = duration/60;
        return [NSString stringWithFormat:@"%ld分钟",(long)minutes];
    }else if(duration < 24*60*60){
        NSInteger hours = duration/(60*60);
        NSInteger mintutes = (duration - hours*60*60)/60;
        return [NSString stringWithFormat:@"%ld小时%ld分",(long)hours,(long)mintutes];
    }else{
        NSInteger days = duration/(24*60*60);
        NSInteger hours = (duration - days*24*60*60)/(60*60);
        return [NSString stringWithFormat:@"%ld天%ld小时",(long)days,(long)hours];
    }
}

@end
