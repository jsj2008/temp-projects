//
//  XYAllTypeOrderDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/15.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYOrderDto.h"
#import "XYPICCOrderDto.h"
#import "XYRecycleDto.h"


/*
 *  维修订单+保险订单+回收订单 混排列表数据结构
 */

//订单列表重获新生。。。
typedef NS_ENUM(NSInteger, XYOrderDeviceType) {
    XYOrderDeviceTypeRepair = 1,    //维修机型
    XYOrderDeviceTypeInsurance = 2,    //保险机型
};

@interface XYAllTypeOrderDto : NSObject

@property(strong,nonatomic)NSString* id;
@property(strong,nonatomic)NSString* order_num;//魅族专享订单号。。。
@property(assign,nonatomic)XYBrandType bid;
@property(strong,nonatomic)NSString* uName;
@property(strong,nonatomic)NSString* uMobile;
@property(assign,nonatomic)XYAllOrderType type;
@property(assign,nonatomic)NSInteger TotalAccount;
@property(strong,nonatomic)NSString* FaultTypeDetail;
@property(strong,nonatomic)NSString* MouldName;
@property(assign,nonatomic)BOOL payStatus;
@property(strong,nonatomic)NSString* reserveTime;//时间戳
@property(strong,nonatomic)NSString* reserveTime2;//时间戳
@property(strong,nonatomic)NSString* FinishTime;//时间戳
@property(strong,nonatomic)NSString* color;
@property(assign,nonatomic)CGFloat billTime;//时间戳 如为0则未结算
@property(strong,nonatomic)NSString* lng;
@property(strong,nonatomic)NSString* lat;
//@property(assign,nonatomic)XYPaymentType payment;
@property(assign,nonatomic)XYOrderType order_status;
@property(strong,nonatomic)NSString* origin_order_id;
@property(strong,nonatomic)NSString* payment_name;
@property(assign,nonatomic)BOOL isVip;
//平台费
@property(copy,nonatomic)NSString* platform_fee;
@property(assign,nonatomic)XYPlatformPayStatus platform_pay_status;
@property(copy,nonatomic)NSString* platform_pay_status_name;
@property(assign,nonatomic)BOOL platform_fee_selected;

//!!不同订单有不同定义 XYPICCOrderStatus XYOrderStatus
@property(assign,nonatomic)NSInteger status;

//非接口参数
@property(strong,nonatomic) NSString* statusString;
@property(strong,nonatomic) NSString* repairTimeString;
@property(strong,nonatomic) NSString* finishTimeString;
@property(strong,nonatomic) NSAttributedString* priceAndPay;
@property(strong,nonatomic) NSString* payIconName;

//左滑按钮
@property(strong,nonatomic)NSMutableArray* rightUtilityButtons;


//用维修订单数据更新dto
+ (XYAllTypeOrderDto*)convertRepairOrder:(XYOrderBase*)orderBase from:(XYAllTypeOrderDto*)originOrder;

@end




