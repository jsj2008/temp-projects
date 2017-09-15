//
//  XYAPIService+UserAPI.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V2API)


/**
 *  修改零件来源
 *
 *  @param orderId    订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
//-(NSInteger)doEditPartSource:(NSString*)orderId house:(BOOL)isOutWareHouse price:(NSInteger)money success:(void (^)())success errorString:(void (^)(NSString *))errorString;

/**
 *  零件列表
 *
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getMyPartsList:(void (^)(NSArray* partsList))success errorString:(void (^)(NSString *))errorString;

/**
 *  零件领取记录
 *
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getClaimRecordsList:(NSInteger)p success:(void (^)(NSArray* recordsList,NSInteger sum))success errorString:(void (^)(NSString *))errorString;

/**
 *  确认领取
 *
 *  @param claimId     批次
 *  @param success     成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)confirmClaiming:(NSString*)claimId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))errorString;

/**
 *  版本更新
 *  dy_version
 */
- (void)getVersionUpdate:(NSString*)build success:(void (^)(NSString* version,NSString* desc, NSString* appId))success errorString:(void (^)(NSString *))errorString;


/**
 *  判断支付方式可用性
 */
- (NSInteger)getPayOpenList:(void (^)(NSArray<XYFeatureDto*>* openList))success errorString:(void (^)(NSString *))errorString;

@end
