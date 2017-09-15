//
//  XYAPIService+V7API.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V7API)

/**
 *  工程师创建请假申请*
 *  日期 格式：20160301
 */
- (NSInteger)submitLeaveRequest:(XYLeaveType)leave_type from:(NSString*)start_at to:(NSString*)end_at reason:(NSString*)reason success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  考勤列表
 *  格式：201603
 */
- (NSInteger)getAttendenceList:(NSString*)time success:(void (^)(NSArray<XYAttendanceDto*>* resultList))success errorString:(void (^)(NSString *))error;

/**
 *  请假列表
 *  格式：201603
 */
- (NSInteger)getLeaveList:(NSString*)time success:(void (^)(NSArray<XYLeaveDto*>* resultList))success errorString:(void (^)(NSString *))error;

/**
 *  考勤数据
 *  格式：201603
 */
- (NSInteger)getAttendenceStaticis:(NSString*)time success:(void (^)(NSInteger holiday_days,NSInteger leave_days))success errorString:(void (^)(NSString *))error;

/**
 *  登录获取验证码
 */
- (NSInteger)getVerifyCode:(NSString*)workerId success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  获取协议及状态
 */
- (NSInteger)getAgreementConfirmingStatus:(NSString*)workerId success:(void (^)(XYAgreementDto* agreement))success errorString:(void (^)(NSString *))error;

/**
 *  工程师同意协议
 */
- (NSInteger)confirmAgreement:(NSString*)workerId type:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


@end
