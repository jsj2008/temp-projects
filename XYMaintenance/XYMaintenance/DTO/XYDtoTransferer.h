//
//  XYDtoTransferer.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  时间时间戳等等各种转换
 */
@interface XYDtoTransferer : NSObject


+ (NSString*)getTimeStampFromDate:(NSDate*)date;

+ (NSString*)getTimeStampFromDateString:(NSString*)date;

+ (NSString*)getDateStringFromTimeStamp:(NSString*)timeStamp;

+ (NSString*)getDateStringFromTimeStamp_notime:(NSString*)timeStamp;

+ (NSDate*)getDateFromTimeStamp:(NSString*)timeStamp;

+ (NSString *)xy_reservetimeTransform:(NSString*)reserveTime reserveTime2:(NSString*)reserveTime2;



@end
