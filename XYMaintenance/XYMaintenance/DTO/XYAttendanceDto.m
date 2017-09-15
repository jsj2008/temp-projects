//
//  XYAttendanceDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAttendanceDto.h"
#import "XYStringUtil.h"
#import "NSDate+DateTools.h"

@implementation XYAttendanceDto

+ (NSArray*)leaveTypeArray{
    return @[@"休假",@"事假",@"病假",@"产假",@"丧假"];
}

- (NSString*)onlineStr{
    if ([XYStringUtil isNullOrEmpty:_onlineStr]) {
        if (self.online_at < 0.5) {
            _onlineStr = @"--:--";
        }else{
           _onlineStr =  [[NSDate dateWithTimeIntervalSince1970:self.online_at] formattedDateWithFormat:@"HH:mm"];
        }
    }
    return _onlineStr;
}

- (NSString*)offlineStr{
    if ([XYStringUtil isNullOrEmpty:_offlineStr]) {
        if (self.offline_at < 0.5) {
            _offlineStr = @"--:--";
        }else{
            _offlineStr =  [[NSDate dateWithTimeIntervalSince1970:self.offline_at] formattedDateWithFormat:@"HH:mm"];
        }
    }
    return _offlineStr;
}

- (NSString*)leaveTypeStr{
    
    if ([XYStringUtil isNullOrEmpty:_leaveTypeStr]) {
        NSArray* typeArray = [XYAttendanceDto leaveTypeArray];
        NSInteger index = self.leave_type;
        if (index < [typeArray count] && index >= 0) {
            _leaveTypeStr = typeArray[index];
        }
    }
    return _leaveTypeStr;
}

@end

@implementation XYAttendanceListDto

@end

@implementation XYAttendanceStatistics

@end

@implementation XYLeaveDto

- (BOOL)shouldShowReview{
    return (self.status == XYLeaveReviewTypeRejected) && (![XYStringUtil isNullOrEmpty:self.checked_remark]);
}
   
- (NSString*)leaveTypeStr{
    if ([XYStringUtil isNullOrEmpty:_leaveTypeStr]) {
        NSArray* typeArray = [XYAttendanceDto leaveTypeArray];
        NSInteger index = self.leave_type;
        if (index < [typeArray count] && index >= 0) {
            _leaveTypeStr =  typeArray[index];
        }
    }
    return _leaveTypeStr;
}

- (NSString*)updatedStr{
    if ([XYStringUtil isNullOrEmpty:_updatedStr]) {
        if(self.checked_at < 0.5){
           _updatedStr = @"无";
        }else{
           _updatedStr = [[NSDate dateWithTimeIntervalSince1970:self.checked_at] formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
        }
    }
    return _updatedStr;
}

- (NSString*)statusStr{
    switch (self.status) {
        case XYLeaveReviewTypeApproved:
            return @"已通过";
            break;
        case XYLeaveReviewTypeSubmitted:
            return @"待审核";
            break;
        case XYLeaveReviewTypeRejected:
            return @"已拒绝";
            break;
        default:
            break;
    }
    return @"未知";
}
@end
