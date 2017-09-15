//
//  XYReservetimeDto.m
//  XYMaintenance
//
//  Created by lisd on 2017/7/28.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYReservetimeDto.h"
@implementation XYReservetimePeriodDto
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_start_time forKey:@"start_time"];
    [aCoder encodeObject:_start_timestamp forKey:@"start_timestamp"];
    [aCoder encodeObject:_next_time forKey:@"next_time"];
    [aCoder encodeObject:_next_timestamp forKey:@"next_timestamp"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _start_time = [aDecoder decodeObjectForKey:@"start_time"];
        _start_timestamp = [aDecoder decodeObjectForKey:@"start_timestamp"];
        _next_time = [aDecoder decodeObjectForKey:@"next_time"];
        _next_timestamp = [aDecoder decodeObjectForKey:@"next_timestamp"];
    }
    return self;
}
@end

@implementation XYReservetimeDateDto
+ (NSDictionary *)mj_objectClassInArray
{
    return @{
             @"periods":[XYReservetimePeriodDto class],// 或者
             //             @"users":[User class],
             };
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_dateTimestamp forKey:@"dateTimestamp"];
    [aCoder encodeObject:_dateStr forKey:@"dateStr"];
    [aCoder encodeObject:_periods forKey:@"periods"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _dateTimestamp = [aDecoder decodeObjectForKey:@"dateTimestamp"];
        _dateStr = [aDecoder decodeObjectForKey:@"dateStr"];
        _periods = [aDecoder decodeObjectForKey:@"periods"];
    }
    return self;
}

@end
