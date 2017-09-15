//
//  XYAPIService+V5API.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService+V5API.h"

static NSString* const PROMOTION_BONUS = @"activities/get-promotion-datas";//日月总
static NSString* const PROMOTION_BONUS_LIST = @"activities/get-promotion-list-by-type";//列表
static NSString* const READING_LOG = @"activities/open-announce-log";//阅读公告记录


@implementation XYAPIService (V5API)

- (NSInteger)getPromotionBonusData:(void (^)(XYPromotionBonusDto* bonus))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PROMOTION_BONUS parameters:nil isPost:false success:^(id responseJson) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS) {
            XYPromotionBonusDto* bonus = [XYPromotionBonusDto mj_objectWithKeyValues:dto.data];
            success(bonus);
        }else{
            error?error(dto.mes):nil;
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPromotionBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray *list, NSInteger sum))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    NSString* typeStr = @"day";
    switch (type) {
        case XYBonusListTypeToday:
            typeStr = @"day";
            break;
        case XYBonusListTypeMonth:
            typeStr = @"month";
            break;
        case XYBonusListTypeTotal:
            typeStr = @"total";
            break;
        default:
            break;
    }
    [parameters setValue:typeStr forKey:@"type"];
    [parameters setValue:@(p) forKey:@"p"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PROMOTION_BONUS_LIST parameters:parameters isPost:false success:^(id responseJson) {
        XYListDtoContainer* dto = [XYListDtoContainer mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT) {
            NSArray* bonusList = [XYPromotionBonusDetail mj_objectArrayWithKeyValuesArray:dto.data];
            success(bonusList,(dto.info.sum > 0)?dto.info.sum:[bonusList count]);
            //预留分页
        }else{
            error?error(dto.mes):nil;
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)logNoticeReading:(NSString*)announce_id success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:announce_id forKey:@"announce_id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:READING_LOG parameters:parameters isPost:false success:^(id responseJson) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS) {
            success();
        }else{
            error?error(dto.mes):nil;
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}


@end
