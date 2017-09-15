//
//  XYAPIService+V11API.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService+V11API.h"
#import "XYStringUtil.h"
#import "NSString+URLCode.h"

static NSString* const PLATFORMFEE_SUBMIT_ACTION = @"order/platformfee-settlement";// 提交平台费
static NSString* const EVALUATION_INFO = @"comment/assessment";// 工程师评价信息
static NSString* const PARTS_SELECTION = @"repairprice/get-parts-info";//配件选项
static NSString* const RESERVE_TIME = @"order/get-reserve-time";//预约时间段数据



@implementation XYAPIService (V11API)
- (NSInteger)submitPlatformFees:(NSArray*)fees trade_number:(NSString*)trade_number success:(void (^)())success errorString:(void (^)(NSString *))errorString{
    
    NSMutableArray *partsArr = [NSMutableArray array];
    for (XYAllTypeOrderDto *feeDto in fees) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"order_id"] = feeDto.id;
        dic[@"pay_sn"] = trade_number;
        [partsArr addObject:dic];
    }

    NSError *error = nil;
    NSString *info_json_str  = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:partsArr options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    parameters[@"info"] = [info_json_str URLEncode];
    
    //
    NSString* key = @"5b46fc265b786a1b5edcf59d6ee06786";
    NSString* signStr = [XYStringUtil md5String:[NSString stringWithFormat:@"%@%@",[XYStringUtil md5String:info_json_str],key]];
    [parameters setValue:signStr forKey:@"sign"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PLATFORMFEE_SUBMIT_ACTION parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success?success():nil;
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (NSInteger)getEvaluationInfoWithAccount:(NSString*)account success:(void (^)(XYEvaluationDto* evaluationDto))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
//    [parameters setValue:account forKey:@"name"];
//    [parameters setValue:password forKey:@"password"];
//    [parameters setValue:code forKey:@"code"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EVALUATION_INFO parameters:parameters isPost:NO success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYEvaluationDto* evaluationDto = [XYEvaluationDto mj_objectWithKeyValues:dto.data];
            success(evaluationDto);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (void)getReservetimeByCityID:(NSString*)city_id success:(void (^)(NSArray* dateList))success errorString:(void (^)(NSString *))errorString {
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:city_id forKey:@"cityId"];
    
    [[XYHttpClient sharedInstance] getRequestWithUrl:@"http://userapi.hiweixiu.com/order/get-reserve-time" parameters:parameters success:^(id response) {
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* dateArr = [XYReservetimeDateDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(dateArr);
        }else{
            errorString(dto.mes);
        }
        
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    
//    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RESERVE_TIME parameters:parameters isPost:false success:^(id response){
//        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
//        if (dto.code == RESPONSE_SUCCESS){
//            NSArray* featuresArray = [XYPartsSelectionDto mj_objectArrayWithKeyValuesArray:dto.data];
//            success(featuresArray);
//        }else{
//            errorString(dto.mes);
//        }
//    }failure:^(NSString *error) {
//        errorString?errorString(error):nil;
//    }];
//    return requestId;
    
}

@end
