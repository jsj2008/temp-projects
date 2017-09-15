//
//  XYReservetimeDto.h
//  XYMaintenance
//
//  Created by lisd on 2017/7/28.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XYReservetimePeriodDto;

@interface XYReservetimeDateDto : NSObject<NSCoding>
@property (nonatomic, copy) NSString *dateTimestamp;
@property (nonatomic, copy) NSString *dateStr;
@property (nonatomic, strong) NSArray <XYReservetimePeriodDto *>*periods;
@end

@interface XYReservetimePeriodDto : NSObject<NSCoding>

@property (nonatomic, copy) NSString *start_time;
@property (nonatomic, copy) NSString *start_timestamp;
@property (nonatomic, copy) NSString *next_time;
@property (nonatomic, copy) NSString *next_timestamp;

@end



