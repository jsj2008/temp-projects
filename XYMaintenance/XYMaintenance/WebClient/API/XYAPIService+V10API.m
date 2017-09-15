//
//  XYAPIService+V10API.m
//  XYMaintenance
//
//  Created by lisd on 2017/2/21.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService+V10API.h"
#import "NSString+URLCode.h"

static NSString* const NEWS_SORT_LIST = @"activities/annoncement-category";//公告分类列表
static NSString* const PART_AMOUNT_LIST = @"parts/get-engineer-uselimit";//零件额度
static NSString* const PART_APPLYLOG_LIST = @"partsget-engineer-apply-part-total-log";//零件申请批次
static NSString* const PART_APPLYLOG_DETAIL_LIST = @"parts/get-engineer-apply-part-detail-log";//零件批次详情
static NSString* const PART_APPLY_ACTION = @"parts/apply";//零件申请
static NSString* const SWITCH_CONFIG_LIST = @"config/lists";//开关配置列表




@implementation XYAPIService (V10API)
- (NSInteger)getNewsSortList:(void (^)(NSArray* newsSortList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:NEWS_SORT_LIST parameters:nil isPost:false success:^(id response){
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYNewsSortDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info?listDto.info.sum : [array count]);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPartAmountSuccess:(void (^)(XYPartsAmountDto* partsAmountDto))success errorString:(void (^)(NSString *))error{
    
    NSInteger requestId = [[XYHttpClient sharedInstance] requestPath:PART_AMOUNT_LIST parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYPartsAmountDto* partsAmountDto = [XYPartsAmountDto mj_objectWithKeyValues:dto.data];
            success(partsAmountDto);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPartsApplyLogFrom:(NSString*)searchStartTime to:(NSString*)searchEndTime page:(NSInteger)page success:(void (^)(NSArray* partsLogList,NSInteger sum))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:searchStartTime forKey:@"start_time"];
    [parameters setValue:searchEndTime forKey:@"end_time"];
    [parameters setValue:@(page) forKey:@"page"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PART_APPLYLOG_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:dto.data];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPartsApplyLogDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            errorString(dto.mes);
        }

    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (NSInteger)getPartsApplyLogDetailByApplyLogId:(NSString*)applyLogId success:(void (^)(NSArray* partsLogDetailList,NSInteger sum))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:applyLogId  forKey:@"log_id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PART_APPLYLOG_DETAIL_LIST parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPartsApplyLogDetailDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array,array.count);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (NSInteger)submitParts:(NSArray*)parts success:(void (^)())success errorString:(void (^)(NSString *))errorString{
    
    NSMutableArray *partsArr = [NSMutableArray array];
    for (XYPartsSelectionDto *part in parts) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"id"] = part.part_id;
        dic[@"price"] = part.master_avg_price;
        dic[@"num"] = [NSString stringWithFormat:@"%ld", (long)part.count];
        [partsArr addObject:dic];
    }
    
    NSDictionary *partsDic = @{@"parts":partsArr};
    NSError *error = nil;
    NSString *createJSON  = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:partsDic options:NSJSONWritingPrettyPrinted error:&error] encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    parameters[@"parts_info"] = [createJSON URLEncode];

    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PART_APPLY_ACTION parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)getSwitchConfiguration:(void (^)(XYConfigDto* config))success errorString:(void (^)(NSString *))errorString{
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:SWITCH_CONFIG_LIST parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYConfigDto* config = [XYConfigDto mj_objectWithKeyValues:dto.data];
            success(config);
        }else{
            errorString(dto.mes);
        }
    }failure:^(NSString *error){
        errorString?errorString(error):nil;
    }];
    return requestId;
}


@end
