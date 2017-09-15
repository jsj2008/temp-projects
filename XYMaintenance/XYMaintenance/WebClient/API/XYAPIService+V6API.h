//
//  XYAPIService+V6API.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/13.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V6API)

/*
 *  回收机型列表
 *
 */
- (NSInteger)getRecycleDevicesList:(void (^)(NSDictionary* deviceDic))success errorString:(void (^)(NSString *))error;

/*
 *  回收选项列表 post
 *  id -> 机型id
 */
- (NSInteger)getRecycleSelectionsList:(NSString*)mouldid success:(void (^)(NSArray* selectionsList))success errorString:(void (^)(NSString *))error;

/*
 *  获取回收估价 post
 *  id -> 机型id
 *  attr -> 选项
 */
- (NSInteger)getEstimatePriceOfDevice:(NSString*)mouldid selections:(NSString*)attr success:(void (^)(NSInteger price))success errorString:(void (^)(NSString *))error;

/*
 *  创建回收订单
 */
- (NSInteger)createOrUpdateRecycleOrder:(NSString*)orderId device:(NSString*)mould_id selections:(NSString*)attr price:(NSInteger)price serialNumber:(NSString*)device_sn remark:(NSString*)remark name:(NSString*)user_name phone:(NSString*)mobile identity:(NSString*)id_card province:(NSString*)province city:(NSString*)city area:(NSString*)district address:(NSString*)address signPic:(NSString*)sign_url payType:(XYRecyclePayType)payment_method account:(NSString*)account_number success:(void (^)(NSString* orderId))success errorString:(void (^)(NSString *))error;

/*
 *  改状态
 */
- (NSInteger)turnRecycleOrderStatus:(NSString*)orderId into:(XYRecycleOrderStatus)status success:(void (^)())success errorString:(void (^)(NSString *))error;

/*
 *  回收订单详情
 */
- (NSInteger)getRecycleOrderDetail:(NSString*)orderId success:(void (^)(XYRecycleOrderDetail* order))success errorString:(void (^)(NSString *))error;

/*
 *  全系订单列表
 */
- (NSInteger)getAllOrderList:(BOOL)isNew page:(NSInteger)page success:(void (^)(NSArray<XYAllTypeOrderDto *>* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;
/*
 *  已完成订单列表
 */
- (NSInteger)getCompleteOrderList:(NSInteger)page success:(void (^)(NSMutableArray<XYAllTypeOrderDto*>* userOrderList, NSArray<XYAllTypeOrderDto*>* unpaidfeeList, NSArray<XYAllTypeOrderDto*>* paidfeeList, NSInteger sum))success errorString:(void (^)(NSString *))error;
/*
 *  全系结算订单列表
 */
- (NSInteger)getAllClearOrderList:(NSString*)time page:(NSInteger)page success:(void (^)(NSArray<XYAllTypeOrderDto*>* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/*
 *  有结算订单的日期的列表
 */
- (NSInteger)getAllDaysWithClearOrders:(void (^)(NSArray<NSString*>* daysList))success errorString:(void (^)(NSString *))error;

/*
 *  编辑维修订单的照片
 */
- (NSInteger)editRepairOrder:(NSString*)orderId
                         bid:(XYBrandType)bid
                      photo1:(NSString*)devnopic1
                      photo2:(NSString*)devnopic2
                      photo3:(NSString*)devnopic3
                      photo4:(NSString*)devnopic4
                     success:(void (^)())success
                 errorString:(void (^)(NSString *))error;

/*
 *  回收提成列表
 */
- (NSInteger)getRecycleBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray* bonusList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  维修选项
 *  {"code":200,"data":{"id":"5245","order_id":"31904","is_fixed":"没有","is_miss":"完整","is_wet":"没有","is_deformed":"没有","is_recycle":"没有","is_used":"否","is_normal":"正常","created_at":"0","updated_at":null},"mes":"success"}
 */
- (NSInteger)getRepairSelections:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYRepairSelections* selections))success errorString:(void (^)(NSString *))error;

/**
 *  上传自拍
 */
- (NSInteger)editWorkerSelfTaking:(NSString*)orderId
                              bid:(XYBrandType)bid
                            photo:(NSString*)img
                              lng:(NSString*)lng
                              lat:(NSString*)lat
                             addr:(NSString*)address
                          success:(void (^)())success
                      errorString:(void (^)(NSString *))error;

@end
