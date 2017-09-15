//
//  XYDtoTransferer.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYDtoTransferer.h"
#import "XYStringUtil.h"
#import "XYConfig.h"
#import "NSDate+DateTools.h"



@implementation XYDtoTransferer

+ (NSString*)getTimeStampFromDate:(NSDate*)date{
    return [NSString stringWithFormat:@"%lld", (long long)[date timeIntervalSince1970]];
}

+ (NSString*)getTimeStampFromDateString:(NSString*)dateString{
    NSDate* date = [XYDtoTransferer getDateFromDateString:dateString];
    return [XYDtoTransferer getTimeStampFromDate:date];
}

+ (NSString*)getDateStringFromTimeStamp:(NSString*)timeStamp{
    if ([XYStringUtil isNullOrEmpty:timeStamp]) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    return [XYDtoTransferer getDateStringFromDate:date];
}

+ (NSString*)getDateStringFromTimeStamp_notime:(NSString*)timeStamp{
    if ([XYStringUtil isNullOrEmpty:timeStamp]) {
        return @"";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
    return [XYDtoTransferer getDateStringFromDate_notime:date];
}

+ (NSDate*)getDateFromTimeStamp:(NSString*)timeStamp{
   return [NSDate dateWithTimeIntervalSince1970:[timeStamp doubleValue]];
}

+ (NSString*)getDateStringFromDate:(NSDate*)date{
    return [date formattedDateWithFormat:@"yyyy/MM/dd HH:mm"];
}

+ (NSString*)getDateStringFromDate_notime:(NSDate*)date{
    return [date formattedDateWithFormat:@"yyyy/MM/dd"];
}

+ (NSDate*)getDateFromDateString:(NSString*)str{
    return [NSDate dateWithString:str formatString:@"yyyy/MM/dd HH:mm"];
}

+ (NSString *)xy_reservetimeTransform:(NSString*)reserveTime reserveTime2:(NSString*)reserveTime2{
    NSString *date = [[NSDate dateWithTimeIntervalSince1970:[reserveTime doubleValue]] formattedDateWithFormat:@"yyyy/MM/dd"];
    NSString *startTime = [[NSDate dateWithTimeIntervalSince1970:[reserveTime doubleValue]] formattedDateWithFormat:@"HH:mm"];
    NSString *nextTime =  [[NSDate dateWithTimeIntervalSince1970:[reserveTime2 doubleValue]] formattedDateWithFormat:@"HH:mm"];
    NSString *repairTimeString;
    if ([reserveTime isEqualToString:reserveTime2]) {
        repairTimeString =  [[NSDate dateWithTimeIntervalSince1970:[reserveTime doubleValue]] formattedDateWithFormat:@"yyyy/MM/dd HH:mm"];
    }else {
        repairTimeString = [NSString stringWithFormat:@"%@ %@-%@", date, startTime, nextTime];
    }
    return repairTimeString;
}


@end
