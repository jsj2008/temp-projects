//
//  XYAttendanceDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYLeaveType) {
    XYLeaveTypeHoliday = 0,    //休假
    XYLeaveTypeCasual = 1,    //事假
    XYLeaveTypeSick = 2,  //病假
    XYLeaveTypeBirth = 3,
    XYLeaveTypeDeath = 4,
};

typedef NS_ENUM(NSInteger, XYAttendenceType) {
    XYAttendenceTypeAbsence = 0,    //缺席
    XYAttendenceTypeHoliday = 1,    //休假
    XYAttendenceTypeWorking = 2,  //正常
};

typedef NS_ENUM(NSInteger, XYLeaveReviewType) {
    XYLeaveReviewTypeUnknown = 0, //未知，没请假
    XYLeaveReviewTypeSubmitted = 1,    //已提交
    XYLeaveReviewTypeApproved = 2,    //审核通过
    XYLeaveReviewTypeRejected = 3,  //审核拒绝
};

@interface XYAttendanceDto : NSObject

@property(nonatomic,copy)NSString* create_at;//2016-04-30
@property(nonatomic,assign)CGFloat online_at;//戳
@property(nonatomic,assign)CGFloat offline_at;//戳
@property(nonatomic,assign)XYAttendenceType status;
@property(nonatomic,assign)XYLeaveType leave_type;
@property(nonatomic,copy)NSString* reason;
@property(nonatomic,assign)XYLeaveReviewType leave_status;

+(NSArray*)leaveTypeArray;

@property(nonatomic,copy)NSString* onlineStr;
@property(nonatomic,copy)NSString* offlineStr;
@property(nonatomic,copy)NSString* leaveTypeStr;

@end

@interface XYAttendanceStatistics : NSObject
@property(nonatomic,assign)NSInteger holiday_days;
@property(nonatomic,assign)NSInteger leave_days;
@end

@interface XYAttendanceListDto : NSObject
@property(strong,nonatomic)XYAttendanceStatistics* statistics;
@property(strong,nonatomic)NSArray<XYAttendanceDto*>* list;
@end

@interface XYLeaveDto : NSObject
@property(nonatomic,copy)NSString* leave_at;//不是时间戳
@property(nonatomic,assign)XYLeaveType leave_type;
@property(nonatomic,copy)NSString* reason;
@property(nonatomic,copy)NSString* checked_remark;//拒绝理由
@property(nonatomic,assign)XYLeaveReviewType status;
@property(nonatomic,copy)NSString* checked_by;//审核人
@property(nonatomic,assign)CGFloat checked_at;//审核时间chuo

@property(nonatomic,assign)BOOL isExpanded;//cell是否展开
@property(nonatomic,assign)BOOL shouldShowReview;
@property(nonatomic,copy)NSString* updatedStr;
@property(nonatomic,copy)NSString* leaveTypeStr;
@property(nonatomic,copy)NSString* statusStr;
@end


