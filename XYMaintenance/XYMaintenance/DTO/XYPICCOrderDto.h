//
//  XYPICCOrderDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 保险订单
 */

typedef NS_ENUM(NSInteger, XYPICCOrderStatus){
    XYPICCOrderStatusNothing =  -1,     //未知
    XYPICCOrderStatusCreated = 0,       //已提交
    XYPICCOrderStatusAccepted = 1,      //已受理
    XYPICCOrderStatusPaid = 2,          //已支付
    XYPICCOrderStatusValid = 3,         //已生效
    XYPICCOrderStatusUsed = 6,          //已使用
};

@interface XYPICCCompany : NSObject
@property(strong,nonatomic)NSString* id;
@property(strong,nonatomic)NSString* name;
@end

@interface XYPICCPlan : NSObject
@property(strong,nonatomic)NSString* id;
@property(strong,nonatomic)NSString* insurer_id;//XYPICCCompany的id
@property(strong,nonatomic)NSString* name;
@end

@interface XYPICCPrice : NSObject
@property(strong,nonatomic)NSString* id;
@property(assign,nonatomic)NSInteger price;//保险价格
@property(assign,nonatomic)NSInteger push;//提成
@end

@interface XYPICCOrderDto : NSObject

@property(copy,nonatomic)NSString* odd_number;
@property(strong,nonatomic)NSString* user_name;
@property(strong,nonatomic)NSString* user_mobile;
@property(strong,nonatomic)NSString* order_id;//维修订单
@property(assign,nonatomic)NSInteger price;
@property(strong,nonatomic)NSString* mould_name;
@property(assign,nonatomic)XYPICCOrderStatus status;
@property(assign,nonatomic)BOOL pay_status;
@property(strong,nonatomic)NSString* confirm_pay_dt;

+ (NSString*)getStatusString:(XYPICCOrderStatus)status;

@property(strong,nonatomic)NSAttributedString* priceAndPay;
@property(strong,nonatomic)NSString* statusStr;
@end

@interface XYPICCOrderDetail : XYPICCOrderDto

@property(strong,nonatomic)NSString* insurance_oid;
@property(strong,nonatomic)NSString* address;
@property(strong,nonatomic)NSString* city;    //id
@property(strong,nonatomic)NSString* district;//id
@property(strong,nonatomic)NSString* brand_id;
@property(strong,nonatomic)NSString* mould_id;
@property(strong,nonatomic)NSString* insurer_id;
@property(strong,nonatomic)NSString* coverage_id;
@property(assign,nonatomic)NSInteger equip_price;
@property(assign,nonatomic)NSInteger push_money;//提成
@property(strong,nonatomic)NSString* imei;
@property(strong,nonatomic)NSString* user_email;
@property(strong,nonatomic)NSString* id_number;
@property(strong,nonatomic)NSString* equip_pic1;
@property(strong,nonatomic)NSString* equip_pic2;
@property(strong,nonatomic)NSString* idcard_pic1;
@property(strong,nonatomic)NSString* idcard_pic2;
@property(strong,nonatomic)NSString* engineer_remark;

@property(strong,nonatomic)NSString* city_name;
@property(strong,nonatomic)NSString* district_name;
@property(strong,nonatomic)NSString* company_name;
@property(strong,nonatomic)NSString* insurance_name;
@property(strong,nonatomic)NSString* rate_id;

@property(strong,nonatomic)NSString* product_name;
@property(strong,nonatomic)NSString* brand_name;

//@property(assign,nonatomic)NSInteger mould_price;

//@property(strong,nonatomic)NSString* odd_number;
//@property(strong,nonatomic)NSString* order_id;//维修订单
//@property(strong,nonatomic)NSString* user_name;
//@property(strong,nonatomic)NSString* user_mobile;
//@property(assign,nonatomic)NSInteger price;//保险价格
//@property(strong,nonatomic)NSString* mould_name;
//@property(assign,nonatomic)BOOL pay_status;
//
//@property(strong,nonatomic)NSString* reserveTime;
//
//@property(strong,nonatomic)NSString* insuranceCompany;//
//@property(strong,nonatomic)NSString* insuranceType;//
//
//

@end
