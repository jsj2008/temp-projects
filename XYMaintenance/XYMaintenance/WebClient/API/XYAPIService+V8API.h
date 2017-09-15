//
//  XYAPIService+V8API.h
//  XYMaintenance
//
//  Created by Kingnet on 16/10/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V8API)

/**
 *  获得超时预约单（地图展示）
 *
 *  @param success  成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getOverTimeMapOrderList:(NSInteger)page success:(void (^)(NSArray* orderList))success errorString:(void (^)(NSString *))error;

/**
 *  修改订单的保内外状态
 *
 *  @param orderId  订单号
 *  @param status   状态
 *
 *  @return requestId
 */
- (NSInteger)changeGuarranteeStatusOfOrder:(NSString*)orderId into:(XYGuarrantyStatus)status success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  编辑订单的发票
 *
 *  @param orderId  订单号
 *  @param receipt_pic   url
 *
 *  @return requestId
 */
- (NSInteger)editReceiptOfOrder:(NSString*)orderId
                            bid:(XYBrandType)bid
                            url:(NSString*)receipt_pic
                        success:(void (^)())success
                    errorString:(void (^)(NSString *))error;


/**
 *  编辑魅族订单的维修方案
 *
 *  @param id  订单号
 *  @param planid  新的维修报价id组成的字符串 例如3,4,5
 *  @param mould  改机型
 *
 *  @return requestId
 */
- (NSInteger)editMeizuPlansOfOrder:(NSString*)orderId
                             plans:(NSString*)planid
                            device:(NSString*)mould  //是id
                             color:(NSString*)color  //是id
                           success:(void (^)())success
                       errorString:(void (^)(NSString *))error;

/**
 *  编辑魅族vip码
 *
 *  @param id  订单号
 *  @param vip  vip码
 *
 *  @return requestId
 */
- (NSInteger)editVIPCodeInto:(NSString*)vip
                     ofOrder:(NSString*)orderId
                         bid:(XYBrandType)bid
                     success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  编辑微信推广照片
 *
 *  @param oid  订单号
 *  @param weixin_promotion_img  url
 *
 *  @return requestId
 */
- (NSInteger)addWechatPromotionPhoto:(NSString*)weixin_promotion_img
                               order:(NSString*)oid
                                 bid:(XYBrandType)bid
                             success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  （创建订单时）向用户手机发送验证码
 *
 *  @param phoneNum  手机号
 *
 *  @return requestId
 */
- (NSInteger)sendVerifyCodeToUserPhone:(NSString*)phoneNum success:(void (^)())success errorString:(void (^)(NSString *))error;



/**
 *  地推排行
 *
 *  @param type 排行榜类型 XYRankingListType
 *
 *  @return requestId
 */
- (NSInteger)getPromotionRankList:(NSInteger)p type:(XYRankingListType)type success:(void (^)(XYPromotionRankDto* myRank, NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error;

@end
