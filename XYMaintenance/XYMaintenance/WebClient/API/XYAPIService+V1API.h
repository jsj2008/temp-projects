//
//  XYAPIService+V1API.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V1API)

/**
 *  订单列表 (废弃) -> API6
 *
 *  @param page     页数
 *  @param isNew    新订单还是完成订单
 *  @param success  成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
//- (NSInteger)getOrderList:(NSInteger)page isNew:(BOOL)isNewOrder success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  获得今日预约单（地图展示）
 *
 *  @param page     页数
 *  @param isNew    新订单还是完成订单
 *  @param success  成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getTodayMapOrderList:(NSInteger)page success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;
/**
 *  获取设备类型
 *
 *  @param success 成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getAllDevicesType:(XYOrderDeviceType)type success:(void (^)(NSDictionary* deviceDic))success errorString:(void (^)(NSString *))error;

/**
 *  获取颜色
 *
 *  @param colorId 颜色id
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getColorByDeviceId:(NSString*)mould_id
                          fault:(NSString*)fault_id
                            bid:(XYBrandType)bid
                        success:(void (^)(NSArray* colorArray))success
                    errorString:(void (^)(NSString *))error;

/**
 *  获取故障类型
 *  @param order_status 是否属于售后订单修改维修方案流程  20170206需求：售后订单只能选择故障大类“调试”,需要屏蔽其它选项
 *  @param success 成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getAllFaultsType:(XYOrderType)order_status success:(void (^)(NSArray* faultArray))success errorString:(void (^)(NSString *))error;

/**
 *  获取维修方案
 *
 *  @param moudleid  设备id
 *  @param faulttype 故障类型
 *  @param brandid   品牌id
    @param 
 *  @param success   成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getRepairingPlanOfDevice:(NSString*)mould_id
                                fault:(NSString*)fault_id
                                color:(NSString*)color_id
                          orderStatus:(XYOrderType)order_status
                              success:(void (^)(NSArray* planArray))success
                          errorString:(void (^)(NSString *))error;

/**
 *  获取城市列表
 *
 *  @param success 成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getCityList:(void (^)(NSDictionary* citiesArray))success errorString:(void (^)(NSString *))error;

/**
 *  获取区域列表
 *
 *  @param success 成功回调
 *  @param error    失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getDistrictList:(NSString*)cityId success:(void (^)(NSDictionary* districtsArray))success errorString:(void (^)(NSString *))error;

/**
 *  取消订单
 *
 *  @param orderId   订单号
 *  @param reason   原因
 *  @param success   成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)cancelOrder:(NSString*)orderId reason:(NSString*)reasonId remark:(NSString*)remark bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  修改订单状态
 *
 *  @param orderId 订单号
 *  @param status  7 删除 5 完成 3 门店 2开始
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)changeStatusOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


/**
 *  出发
 *
 *  @param orderId   订单号
 *  @param success   成功回调
 *  @param error     失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)setOutOrder:(NSString*)orderId
                     bid:(XYBrandType)bid
                 address:(NSString*)address
                     lat:(NSString*)lat
                     lng:(NSString*)lng
                 success:(void (^)())success
             errorString:(void (^)(NSString *))error;

/**
 *  维修完成
 *
 *  @param orderId   订单号
 *  @param hasFaults 是否有额外故障
 *  @param success   成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)completeOrder:(NSString*)orderId
                       bid:(XYBrandType)bid
           withOtherFaults:(BOOL)hasFaults
  withOtherFaults_noRecyle:(BOOL)hasFaults_noRecyle
                  is_fixed:(NSInteger)is_fixed
                  is_miss:(NSInteger)is_miss
                  is_wet:(NSInteger)is_wet
                  is_deformed:(NSInteger)is_deformed
                  is_recycle:(NSInteger)is_recycle
                  is_used:(NSInteger)is_used
                 is_normal:(NSInteger)is_normal
                   address:(NSString*)address
                       lat:(NSString*)lat
                       lng:(NSString*)lng
                   success:(void (^)())success
               errorString:(void (^)(NSString *))error;

/**
 *  现金支付
 *
 *  @param orderId 订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)payOrderByCash:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


/**
 *  微信支付
 *
 *  @param orderId 订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)payByService:(XYQRCodePayType)type order:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(NSString* imgUrl,NSString* price))success errorString:(void (^)(NSString *))error;



/**
 *  修改设备序列号
 *
 *  @param devno   新序列号
 *  @param orderId 订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)editDeviceSerialNumberInto:(NSString*)devno ofOrder:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;

/**
 *  修改预约时间
 *
 *  @param orderId     订单号
 *  @param reservetime 新预约时间的时间戳
 *  @param success     成功回调
 *  @param error       失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)editOrderTime:(NSString*)orderId newTime:(NSString*)reservetime reservetime2:(NSString*)reservetime2 bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


/**
 *  修改维修方案
 *
 *  @param orderId 订单号
 *  @param planid  新方案id
 *  @param success 成功回调
 *  @param error       失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)editRepairingPlanOfOrder:(NSString*)orderId
                            newPlanId:(NSString*)planid
                              mouldId:(NSString*)mould
                                color:(NSString *)color
                                  bid:(XYBrandType)bid
                              success:(void (^)())success
                          errorString:(void (^)(NSString *))error;

/**
 *  修改维修工备注
 *
 *  @param orderId 订单号
 *  @param content 新备注
 *  @param success 成功回调
 *  @param error       失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)editOrderRemark:(NSString*)orderId remark:(NSString*)content bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error;


/**
 *  订单详情
 *
 *  @param orderId 订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getOrderDetail:(NSString*)orderId type:(XYBrandType)bid success:(void (^)(XYOrderDetail* order))success errorString:(void (^)(NSString *))error;

/**
 *  获取评论
 *
 *  @param orderId 订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getOrderComment:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYPHPCommentDto* order))success errorString:(void (^)(NSString *))error;



/**
 *  添加订单
 *
 *  @param planId   方案编号
 *  @param moudleid 设备类型
 *  @param mobile   用户联系方式
 *  @param name     用户名字
 *
 *  @return requestId
 */
- (NSInteger)addOrderWithPlan:(NSString*)planId
                       device:(NSString*)moudleid
                      colorId:(NSString*)color
                        phone:(NSString*)mobile
                         user:(NSString*)name
                         city:(NSString*)cityid
                     district:(NSString*)areaid
                      address:(NSString*)address
                          lat:(CGFloat)lat
                          lng:(CGFloat)lng
                         code:(NSString*)validCode
                      success:(void (^)())success
                  errorString:(void (^)(NSString *))error;

/**
 *  根据id搜索订单
 *
 *  @param id      订单号
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)searchOrderByKeyword:(NSString*)key success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  高德地图转换api
 *
 *  @param lat     lat
 *  @param lng     lng
 */
- (void)transferCoordinate:(CGFloat)lat and:(CGFloat)lng success:(void (^)(NSArray* locationArray))success errorString:(void (^)(NSString *))errorString;


/**
 *  获取每日的完成订单（交通费用）
 *
 *  @param day      yyyy-mm-dd
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)getDailyCompletedOrders:(NSString*)day success:(void (^)(NSArray* ordersArray))success errorString:(void (^)(NSString *))errorString;

/**
 *  上报交通费 post
 *
 *  @param date      yyyy-mm-dd
 *  @param data      postbody
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)postEditedDailyRoutesRecord:(NSString*)date body:(NSArray*)data success:(void (^)())success errorString:(void (^)(NSString *))errorString;


/**
 *  获取每日交通费信息base
 *
 *  @param date      yyyy-mm-dd
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
-(NSInteger)getTFCDailyInfoOf:(NSString*)date success:(void (^)(XYTFCDailyInfo* info))success errorString:(void (^)(NSString *))errorString;


/**
 *  获取每月交通费信息base
 *
 *  @param month    月份
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
-(NSInteger)getMonthlyInfoOf:(NSInteger)month year:(NSInteger)year success:(void (^)(XYTFCMonthlyInfo* info))success errorString:(void (^)(NSString *))errorString;


/**
 *  获取每日路线信息base
 *
 *  @param date    日期
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
-(NSInteger)getTFCDailyRouteOf:(NSString*)date success:(void (^)(NSArray* info))success errorString:(void (^)(NSString *))errorString;



/**
 *  上报坐标
 *
 *  @param lat     lat
 *  @param lng     lng
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)postCoordinate:(NSString*)lat and:(NSString*)lng success:(void (^)(NSInteger nextUpdate))success errorString:(void (^)(NSString *))error;

@end
