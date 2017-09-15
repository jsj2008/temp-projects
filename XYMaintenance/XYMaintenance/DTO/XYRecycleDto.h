//
//  XYRecycleDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  回收订单
 */

//0.创建成功, 1.已预约, 2.已出发, 3.回收完成, 4.已出售 5.已取消
typedef NS_ENUM(NSInteger, XYRecycleOrderStatus){
    XYRecycleOrderStatusCreated = 0,
    XYRecycleOrderStatusAssigned = 1,
    XYRecycleOrderStatusSetOff = 2,
    XYRecycleOrderStatusDone = 3,
    XYRecycleOrderStatusSold = 4,
    XYRecycleOrderStatusCancelled = 5,
};

//支付类型
typedef NS_ENUM(NSInteger, XYRecyclePayType) {
    XYRecyclePayTypeUnknown = -1,
    XYRecyclePayTypeCompanyWechat = 0,    //公司微信支付
    XYRecyclePayTypeCompanyAlipay = 1,    //公司支付宝支付
    XYRecyclePayTypeWorkerCash = 2,
    XYRecyclePayTypeWorkerWechat = 3,
    XYRecyclePayTypeWorkerAlipay = 4,
};


//回收机型
@interface XYRecycleDeviceDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* ProductId;
@property(copy,nonatomic)NSString* BrandId;
@property(copy,nonatomic)NSString* BrandName;
@property(copy,nonatomic)NSString* MouldName;
@property(copy,nonatomic)NSString* ProductName;
@property(copy,nonatomic)NSString* Pic;
@property(assign,nonatomic)NSInteger avg_price;
@end


@interface XYRecycleSelectionItem : NSObject
@property(copy,nonatomic)NSString* fault_id;
@property(copy,nonatomic)NSString* name;
@end

@interface XYRecycleSelectionsDto : NSObject
@property(copy,nonatomic)NSString* attr_id;
@property(copy,nonatomic)NSString* name;
@property(assign,nonatomic)BOOL option_type;//option_type=0是单选 1是多选
@property(assign,nonatomic)BOOL required ;//required=0是不必选 1是必选
@property(strong,nonatomic)NSArray<XYRecycleSelectionItem*>* detail_info;

@property(assign,nonatomic)BOOL isExpanded;//是否展开选项cell

@end


@interface XYRecycleOrderDetail : NSObject

@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* mould_id;
@property(copy,nonatomic)NSString* mould_name;
@property(strong,nonatomic)NSArray<NSString*>* attr;
@property(assign,nonatomic)NSInteger avg_price;
@property(assign,nonatomic)NSInteger price;
@property(copy,nonatomic)NSString* device_sn;
@property(copy,nonatomic)NSString* remark;
@property(copy,nonatomic)NSString* user_name;
@property(copy,nonatomic)NSString* user_mobile;
@property(copy,nonatomic)NSString* id_card;
@property(copy,nonatomic)NSString* province;
@property(copy,nonatomic)NSString* city;
@property(copy,nonatomic)NSString* district;
@property(copy,nonatomic)NSString* city_name;
@property(copy,nonatomic)NSString* district_name;
@property(copy,nonatomic)NSString* address;
@property(copy,nonatomic)NSString* sign_url;
@property(assign,nonatomic)XYRecyclePayType payment_method;
@property(assign,nonatomic)XYRecycleOrderStatus status;
@property(copy,nonatomic)NSString* account_number;
@property(copy,nonatomic)NSString* reserve_time;
@property(assign,nonatomic)BOOL payment_status;

+ (NSString*)getStatusStringByStatus:(XYRecycleOrderStatus)status;

@property(copy,nonatomic)NSString* attrString;
@property(strong,nonatomic)NSArray* payTypeArray;
@property(strong,nonatomic)NSString* payTypeStr;
@property(strong,nonatomic)NSString* priceAndPay;
@property(strong,nonatomic)NSString* statusStr;
@property(strong,nonatomic)NSMutableArray* rightUtilityButtons;
@property(strong,nonatomic)NSString* buttonTitleStr;//nil则隐藏按钮

@end
