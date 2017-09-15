//
//  XYAdminDto.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/7.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAdminDto.h"
#import "XYStringUtil.h"
#import "NSDate+DateTools.h"
#import "MJExtension.h"


@implementation XYWorkerStatusDto

- (NSString*)statusStr{
    switch (_status) {
        case XYWorkerStatusOffWork:
           return @"结束接单休息中";
        case XYWorkerStatusWorking:
           return @"开始接单中";
        case XYWorkerStatusHangUp:
            return @"挂起";
        case XYWorkerStatusRepairing:
            return @"维修中";
        case XYWorkerStatusInvalid:
            return @"封停";
        default:
                break;
    }
    return @"";
}

- (NSDate*)onlineDate{
    if (!_onlineDate) {
        _onlineDate = [NSDate dateWithTimeIntervalSince1970:[self.online_at doubleValue]];
    }
    return _onlineDate;
}

- (NSString*)onlineTimeStr{//在线时间
    NSTimeInterval deltaTime = [[NSDate date]timeIntervalSinceDate:self.onlineDate];
    if (deltaTime < 0) {
        return @"00:00:00";
    }else{
        NSInteger hour = ((long)deltaTime)/3600;
        NSInteger minute = ((long)deltaTime - hour*3600)/60;
        NSInteger second = ((long)deltaTime)%60;
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hour%24,(long)minute,(long)second];
    }
}

- (BOOL)isToday{
    NSDate* onlineDate = [NSDate dateWithTimeIntervalSince1970:[self.online_at doubleValue]];
    return [onlineDate isSameDay:[NSDate date]];
}
@end

@implementation XYNewsDto

- (NSString*)dateString{
    if ([XYStringUtil isNullOrEmpty:_dateString]) {
        _dateString =  [[NSDate dateWithTimeIntervalSince1970:[self.create_at doubleValue]] formattedDateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return _dateString;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"isNew" : @"show_red_point"};
}
@end

@implementation XYNewsSortDto
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             @"isNew" : @"show_red_point"};
}
@end

@implementation XYReasonDto

@end
