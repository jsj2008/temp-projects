//
//  XYAPIService+V5API.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V5API)

/**
 *  获取提成概况
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getPromotionBonusData:(void (^)(XYPromotionBonusDto* bonus))success errorString:(void (^)(NSString *))error;

/**
 *  获取提成列表
 *
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)getPromotionBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray *list, NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  公告阅读记录
 *  @param announce_id 公告id
 *  @param success 成功
 *  @param error   失败
 *
 *  @return 编号
 */
- (NSInteger)logNoticeReading:(NSString*)announce_id success:(void (^)())success errorString:(void (^)(NSString *))error;

@end
