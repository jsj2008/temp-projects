//
//  XYAPIService+V7API.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService+V7API.h"

static NSString* const REQUEST_LEAVE = @"attendance/leave-create";//请假
static NSString* const ATTENDANCE_LIST = @"attendance/attendance-list";//考勤列表
static NSString* const LEAVE_LIST = @"attendance/leave-list";//请假列表
static NSString* const ATTENDANCE_DATA = @"attendance/get-statistics";//请假数据
static NSString* const VERIFY_CODE = @"activities/get-sms-code";//获取验证码
static NSString* const GET_AGREEMENT = @"activities/get-agreement";//获取协议
static NSString* const CONFIRM_AGREEMENT = @"activities/agree-agreement";//同意协议

@implementation XYAPIService (V7API)

- (NSInteger)submitLeaveRequest:(XYLeaveType)leave_type from:(NSString*)start_at to:(NSString*)end_at reason:(NSString*)reason success:(void (^)())success errorString:(void (^)(NSString *))error{

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(leave_type) forKey:@"leave_type"];
    [parameters setValue:start_at forKey:@"start_at"];
    [parameters setValue:end_at forKey:@"end_at"];
    [parameters setValue:reason forKey:@"reason"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:REQUEST_LEAVE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
            
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

/**
 *  考勤日期
 *  格式：201603
 */
- (NSInteger)getAttendenceList:(NSString*)time success:(void (^)(NSArray<XYAttendanceDto*>* resultList))success errorString:(void (^)(NSString *))error;{
 
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:time forKey:@"time"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ATTENDANCE_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYAttendanceListDto* listDto = [XYAttendanceListDto mj_objectWithKeyValues:dto.data];
            NSArray* list = [XYAttendanceDto mj_objectArrayWithKeyValuesArray:listDto.list];
            success(list);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
  
}


- (NSInteger)getLeaveList:(NSString*)time success:(void (^)(NSArray<XYLeaveDto*>* resultList))success errorString:(void (^)(NSString *))error{

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:time forKey:@"time"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:LEAVE_LIST parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* listDto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYLeaveDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getAttendenceStaticis:(NSString*)time success:(void (^)(NSInteger holiday_days,NSInteger leave_days))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:time forKey:@"time"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ATTENDANCE_DATA parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYAttendanceStatistics* st = [XYAttendanceStatistics mj_objectWithKeyValues:dto.data];
            success(st.holiday_days,st.leave_days);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getVerifyCode:(NSString*)workerId success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:workerId forKey:@"id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:VERIFY_CODE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;

}


- (NSInteger)getAgreementConfirmingStatus:(NSString*)workerId success:(void (^)(XYAgreementDto* agreement))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:workerId forKey:@"id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:GET_AGREEMENT parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYAgreementDto* agm = [XYAgreementDto mj_objectWithKeyValues:dto.data];
            success(agm);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

/**
 *  工程师同意协议
 */
- (NSInteger)confirmAgreement:(NSString*)workerId type:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:workerId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CONFIRM_AGREEMENT parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

@end
