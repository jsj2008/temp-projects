//
//  XYAPIService+V3API.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService+V3API.h"
#import "XYAPPSingleton.h"

static NSString* const BONUS_DATA = @"order/commission";//提成数据
static NSString* const BONUS_LIST = @"order/commission-list";//提成列表
static NSString* const INSURANCE_BONUS_LIST = @"order/insurance-order-push-list";//保险提成列表
static NSString* const ORDER_CLEARED = @"order/clearing";//已结算订单列表
static NSString* const ORDER_SUM = @"order/get-order-total";//分类计数\

static NSString* const TOP_NEWS = @"activities/announcement";//首页公告
static NSString* const NEWS_LIST = @"activities/announcement-list";//公告列表
static NSString* const WORKER_STATUS = @"activities/engineer-state";//工作状态
static NSString* const START_WORKING = @"activities/work-attendance";//上班
static NSString* const END_WORKING = @"activities/sign-work";//下班
static NSString* const RANK_LIST = @"order/ranking-list";//排行榜
static NSString* const MY_RANK = @"order/get-my-ranking";

static NSString* const POOL_ORDERS = @"order/available-order";//可接订单（地图）
static NSString* const ACCEPT_ORDER = @"order/accept-order";//接单
static NSString* const CHECK_PARTS_ENOUGH = @"order/part-situation";//零件是否充足

static NSString* const CANCEL_REASON = @"order/get-cancel-reason";//取消原因列表
static NSString* const PENDING_ORDER =  @"order/checking-order";//审核中的取消订单
static NSString* const DAILY_CANCEL =  @"order/cancelled-order";//按天获取已取消订单

static NSString* const INFO_DETAIL =  @"activities/get-engineer-profile";//个人信息详情

@implementation XYAPIService (V3API)

- (NSInteger)getBonusData:(void (^)(XYBonusDto* bonus))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:BONUS_DATA parameters:nil isPost:false success:^(id responseJson) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS) {
            XYBonusDto* bonus = [XYBonusDto mj_objectWithKeyValues:dto.data];
            success(bonus);
        }else{
            error?error(dto.mes):nil;
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}


/**
 *  获取提成列表
 *
 *  @param isToday 是否只要今天的
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getRepairBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray *, NSInteger))success errorString:(void (^)(NSString *))error{
   
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
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:BONUS_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:dto.data];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYBonusDetailDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getInsuranceBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray* bonusList,NSInteger sum))success errorString:(void (^)(NSString *))error{
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
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:INSURANCE_BONUS_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:dto.data];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPICCBonusDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getClearedOrderList:(NSString*)date isToday:(BOOL)isToday success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    
//    //取缓存、、
//    NSString *key = [NSString stringWithFormat:@"%@/user=%@time=%@",ORDER_CLEARED,[XYAPPSingleton sharedInstance].currentUser.Id,date];
//    if ([self getObjectForPath:key] && [[self getObjectForPath:key] isKindOfClass:[NSArray class]]) {
//        NSArray* array = [self getObjectForPath:key];
//        success(array,array.count);
//        return -1;
//    }
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:date forKey:@"time"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ORDER_CLEARED parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* listDto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYOrderBase mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.sum);
//            if ((!isToday) && listDto.sum > 0 && listDto.sum<=20) {
//                [self cacheResult:array forPath:key];
//            }
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getOrderCount:(void (^)(XYOrderCount* count))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ORDER_SUM parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            XYOrderCount* count = [XYOrderCount mj_objectWithKeyValues:dto.data];
            success(count);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getTopNews:(void (^)(XYNewsDto* topNews))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:TOP_NEWS parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYNewsDto* newsDto = [XYNewsDto mj_objectWithKeyValues:dto.data];
            success(newsDto);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getNewsList:(NSInteger)p categoryId:(NSString *)categoryId success:(void (^)(NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(p) forKey:@"p"];
    [parameters setValue:categoryId forKey:@"category_id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:NEWS_LIST parameters:parameters isPost:false success:^(id response){
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYNewsDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info?listDto.info.sum : [array count]);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getWorkerStatus:(void (^)(XYWorkerStatusDto* workerStatus))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:WORKER_STATUS parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYWorkerStatusDto* workerDto = [XYWorkerStatusDto mj_objectWithKeyValues:dto.data];
            success(workerDto);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)changeWorkingStatusInto:(BOOL)isWorking at:(NSString*)address success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSString* path = isWorking?START_WORKING:END_WORKING;
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:address forKey:@"address"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:path parameters:parameters isPost:false success:^(id response){
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


- (NSInteger)getRankList:(NSInteger)p type:(XYRankingListType)type success:(void (^)(XYRankDto* myRank, NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(p) forKey:@"p"];
    
    NSString* typeStr = nil;
    switch (type) {
        case XYRankingListTypeTodayCountry:
            typeStr = @"today_total";
            break;
        case XYRankingListTypeTodayCity:
            typeStr = @"today_city";
            break;
        case XYRankingListTypeMonthCountry:
            typeStr = @"month_total";
            break;
        case XYRankingListTypeMonthCity:
            typeStr = @"month_city";
            break;
        default:
            break;
    }
    [parameters setValue:typeStr forKey:@"type"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RANK_LIST parameters:parameters isPost:false success:^(id response){
        XYRankListDataDto* listDto = [XYRankListDataDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            XYRankListDto* rankList = [XYRankListDto mj_objectWithKeyValues:listDto.data];
            NSArray* allArray = [XYRankDto mj_objectArrayWithKeyValuesArray:rankList.all_list];
            rankList.all_list = allArray;
            success(rankList.my_mess,rankList.all_list,[rankList.all_list count]);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getMyRank:(void (^)(XYRankDto* myRank))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:MY_RANK parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYRankDto* rankDto = [XYRankDto mj_objectWithKeyValues:dto.data];
            success(rankDto);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)getPoolOrderList:(NSInteger)p success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(p) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:POOL_ORDERS parameters:parameters isPost:false success:^(id response){
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYOrderBase mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYOrderMessageDto* message,NSString* toast))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ACCEPT_ORDER parameters:parameters isPost:false success:^(id response){
        XYRemindOrderDto* dto = [XYRemindOrderDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success(dto.data,dto.remind.status?dto.remind.info:nil);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPartsAvailability:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CHECK_PARTS_ENOUGH parameters:parameters isPost:false success:^(id response){
        XYBoolDto* dto = [XYBoolDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            if(dto.data){
              success();
            }else{
              error(dto.mes);
            }
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)getCancelReason:(void (^)(NSArray<XYReasonDto*>* reasons))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CANCEL_REASON parameters:nil isPost:false success:^(id responseJson) {
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYReasonDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}

/**
 *  取消中订单列表
 *
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getCancelOrderList:(void (^)(NSArray<XYCancelOrderDto*>* pendingOrders, NSArray<NSString*>* oldDays))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PENDING_ORDER parameters:nil isPost:false success:^(id responseJson) {
        XYCancelOrderListDto* dto = [XYCancelOrderListDto mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYCancelOrderDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array,dto.day);
        }else{
            error(dto.mes);
        }
    } failure:^(NSString *errorString) {
        error?error(errorString):nil;
    }];
    return requestId;
}

/**
 *  按天获取取消订单
 *
 *  @param day 2016-03-31
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getCancelOrderByDay:(NSString*)day success:(void (^)(NSArray<XYCancelOrderDto*>* pendingOrders))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:day forKey:@"day"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:DAILY_CANCEL parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* listDto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYCancelOrderDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getMyInfoDetail:(void (^)(XYUserDetail* infoDetail))success errorString:(void (^)(NSString *))error{
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:INFO_DETAIL parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYUserDetail* userDetail = [XYUserDetail mj_objectWithKeyValues:dto.data];
            success(userDetail);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    
    return requestId;

}

@end
