//
//  XYAPIService+V3API.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V3API)

/**
 *  获取提成概况
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getBonusData:(void (^)(XYBonusDto* bonus))success errorString:(void (^)(NSString *))error;


/**
 *  获取提成列表
 *
 *  @param isToday 是否只要今天的
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getRepairBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray* bonusList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  获取保险提成列表
 *
 */
- (NSInteger)getInsuranceBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray* bonusList,NSInteger sum))success errorString:(void (^)(NSString *))error;


/**
 *  获取已结算订单列表 （废弃）-> API6
 *
 *  @param date    时间字符串yyyymmdd
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
//- (NSInteger)getClearedOrderList:(NSString*)date isToday:(BOOL)isToday success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  订单分类总数(废弃)
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
//- (NSInteger)getOrderCount:(void (^)(XYOrderCount* count))success errorString:(void (^)(NSString *))error;


/**
 *  获取置顶公告
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getTopNews:(void (^)(XYNewsDto* topNews))success errorString:(void (^)(NSString *))error;


/**
 *  公告列表
 *
 *  @param p       页数
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getNewsList:(NSInteger)p categoryId:(NSString *)categoryId success:(void (^)(NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  工程师状态
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getWorkerStatus:(void (^)(XYWorkerStatusDto* workerStatus))success errorString:(void (^)(NSString *))error;


/**
 *  上下班
 *
 *  @param isWorking 上/下班
 *  @param location  地址
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)changeWorkingStatusInto:(BOOL)isWorking at:(NSString*)location success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  排行榜
 *
 *  @param p       页数
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getRankList:(NSInteger)p type:(XYRankingListType)type success:(void (^)(XYRankDto* myRank, NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  我的排名/日单/提成数据
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getMyRank:(void (^)(XYRankDto* myRank))success errorString:(void (^)(NSString *))error;

/**
 *  待接订单列表
 *
 *  @param p       页数
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getPoolOrderList:(NSInteger)p success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  接单
 *
 *  @param orderId 订单号
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYOrderMessageDto* message,NSString* toast))success errorString:(void (^)(NSString *))error;

/**
 *  订单配件是否充足
 *
 *  @param orderId 订单号
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getPartsAvailability:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


/**
 *  取消订单原因列表
 *
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getCancelReason:(void (^)(NSArray<XYReasonDto*>* reasons))success errorString:(void (^)(NSString *))error;

/**
 *  取消中订单列表
 *
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getCancelOrderList:(void (^)(NSArray<XYCancelOrderDto*>* pendingOrders, NSArray<NSString*>* oldDays))success errorString:(void (^)(NSString *))error;

/**
 *  按天获取取消订单
 *
 *  @param day 2016-03-31
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getCancelOrderByDay:(NSString*)day success:(void (^)(NSArray<XYCancelOrderDto*>* pendingOrders))success errorString:(void (^)(NSString *))error;

/**
 *  个人信息详情
 *
 *  @param success 成功
 *  @param error   失败
 */
- (NSInteger)getMyInfoDetail:(void (^)(XYUserDetail* infoDetail))success errorString:(void (^)(NSString *))error;

@end
