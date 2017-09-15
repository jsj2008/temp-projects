//
//  XYOrderDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSDate+DateTools.h"
#import "XYDtoContainer.h"

/*
 *  维修订单
 */
typedef NS_ENUM(NSInteger, XYAllOrderType) {
    XYAllOrderTypeRepair = 1,    //维修订单
    XYAllOrderTypeInsurance = 101,    //保险订单
    XYAllOrderTypeRecycle = 102,  //回收订单
};

//订单状态
typedef NS_ENUM(NSInteger, XYOrderStatus){
    XYOrderStatusNothing =  -1,    //未知
    XYOrderStatusPending = 0,       //???
    XYOrderStatusSubmitted = 1,    //已预约
    XYOrderStatusRepairing = 2, //诈尸的维修中
    XYOrderStatusShopRepairing = 3,//门店维修中
    XYOrderStatusCancelled = 4,    //已取消
    XYOrderStatusRepaired = 5,     //维修完成
    XYOrderStatusDone = 6,         //订单完成
    XYOrderStatusOnTheWay = 7,     //已出发
    XYOrderStatusDeleted = 8,      //已删除
};

//支付方式类型
typedef NS_ENUM(NSInteger, XYPaymentType) {
    XYPaymentTypePaidByCash = 0,    //现金支付
    XYPaymentTypeWechat = 1,    //微信支付
    XYPaymentTypeAlipay = 2,    //支付宝支付
    XYPaymentTypeWechatAPP = 3,  //用户app微信支付
    XYPaymentTypeAlipayAPP = 4,  //用户app支付宝支付
    XYPaymentTypeWorkerWechat = 5, //微信工程师代付
    XYPaymentTypeWorkerAlipay = 6, //支付宝工程师代付
    XYPaymentTypeDaoWei = 7,//到位
    XYPaymentTypePICC = 8, //picc
    XYPaymentTypeXPZBT = 9,//小铺周边通
    XYPaymentTypeCMB = 10,//招行
    XYPaymentTypeZhongWei = 18,//中维支付
    XYPaymentTypeSanTi = 28,//三体科技支付
    XYPaymentTypeTaobao = 38,//淘宝支付
    XYPaymentTypePutao = 48,//葡萄生活支付
    XYPaymentTypeYuhang = 58,//余杭人保
};

//支付类型
typedef NS_ENUM(NSInteger, XYQRCodePayType) {
    XYQRCodeCellTypeUnknown = -1,
    XYQRCodeCellTypeWechat = 0,    //微信支付
    XYQRCodeCellTypeAlipay = 1,    //支付宝支付
};

typedef NS_ENUM(NSInteger, XYOrderType) {
    XYOrderTypeNormal = 1,    //普通订单
    XYOrderTypeAfterSales = 2,    //售后订单
};

typedef NS_ENUM(NSInteger, XYGuarrantyStatus) {//保修状态
    XYGuarrantyStatusUknown = 0,    //未选择
    XYGuarrantyStatusInGuarranty = 1,    //ZAIBAO
    XYGuarrantyStatusNoGuarranty = 2,    //不在保
};

//平台费支付状态
typedef NS_ENUM(NSInteger, XYPlatformPayStatus) {
    XYPlatformPayStatusUnpaid = 0,    //未支付
    XYPlatformPayStatusPaid = 1,    //已支付
    XYPlatformPayStatusNoExist = 2,  //不存在
};

/**
 *  订单列表项
 */
@interface XYOrderBase : NSObject
@property(strong,nonatomic)NSString* id;
@property(strong,nonatomic)NSString* order_num;//魅族专享订单号。。。
@property(assign,nonatomic)XYBrandType bid;
@property(strong,nonatomic)NSString* MouldName;
@property(strong,nonatomic)NSString* reserveTime;
@property(strong,nonatomic)NSString* reserveTime2;
@property(strong,nonatomic)NSString* city;
@property(assign,nonatomic)CGFloat TotalAccount;
@property(assign,nonatomic)XYOrderStatus status;
@property(assign,nonatomic)BOOL payStatus;
@property(assign,nonatomic)XYPaymentType payment;
@property(strong,nonatomic)NSString* uMobile;
@property(strong,nonatomic)NSString* color;
@property(strong,nonatomic)NSString* color_id;
@property(strong,nonatomic)NSString* FaultTypeDetail;
@property(strong,nonatomic)NSString* uName;
@property(strong,nonatomic)NSString* FinishTime;//时间戳
@property(assign,nonatomic)CGFloat billTime;//时间戳 如为0则未结算
@property(strong,nonatomic)NSString* lng;
@property(strong,nonatomic)NSString* lat;
@property(assign,nonatomic)XYOrderType order_status;//售后状况
@property(strong,nonatomic)NSString* address;
@property(copy,nonatomic)NSString* devnopic1;
@property(copy,nonatomic)NSString* devnopic2;
@property(copy,nonatomic)NSString* devnopic4;
@property(copy,nonatomic)NSString* devnopic3;//工作证/学生证照片 vip

@property(copy,nonatomic)NSString* receipt_pic;//发票照片
@property(copy,nonatomic)NSString* origin_order_id;//关联订单号
@property(assign,nonatomic)BOOL isVip;//是不是企业服务vip


@property(assign,nonatomic)BOOL iHaveEnoughParts;//有没有零件。。
@property(strong,nonatomic)NSString* eng_name;//工程师，不一定有
@property(strong,nonatomic)NSString* eng_realName;//工程师，不一定有
@property(strong,nonatomic)NSString* eng_mobile;//工程师电话，不一定有

@property(strong,nonatomic)NSString* statusString;
@property(strong,nonatomic)NSMutableArray* rightUtilityButtons;
@property(strong,nonatomic)NSString* repairTimeString;
@property(strong,nonatomic)NSString* finishTimeString;
@property(strong,nonatomic)NSAttributedString* priceAndPay;
@property(strong,nonatomic)NSString* overTimeString;//超时时间

+ (XYOrderStatus)getClickedActionStatus:(XYOrderStatus)currentStatus rightBtnIndex:(NSInteger)index;
+ (NSString*)getStatusString:(XYOrderStatus)status;
//+ (NSString*)getPaymentDes:(XYPaymentType)payment;
+ (NSString*)getPaymentIconName:(XYPaymentType)payment;
+ (NSMutableArray*)getRightUtilityButtonsByStatus:(XYOrderStatus)status payStatus:(BOOL)payStatus bid:(XYBrandType)bid;

@end

@interface XYOrderDetail : XYOrderBase
@property(strong,nonatomic)NSString* RepairType;
@property(strong,nonatomic)NSString* guarantee;
@property(strong,nonatomic)NSString* remark;
@property(strong,nonatomic)NSString* createTime;
@property(assign,nonatomic)BOOL is_comment;
@property(strong,nonatomic)NSString* WarrantyPeriod;
@property(strong,nonatomic)NSString* RepairNumber;
@property(strong,nonatomic)NSString* area;
@property(strong,nonatomic)NSString* brandid;
@property(strong,nonatomic)NSString* moudleid;
@property(strong,nonatomic)NSString* selfRemark;
@property(strong,nonatomic)NSString* cancel_check_remark;
@property(strong,nonatomic)NSString* weixin_promotion_img;
@property(strong,nonatomic)NSString* in_remark;//内部备注
@property(strong,nonatomic)NSString* payment_name;//支付类型
@property(strong,nonatomic)NSString* platform_fee;//平台费
@property(assign,nonatomic)XYPlatformPayStatus platform_pay_status;//平台费状态
@property(copy,nonatomic)NSString* platform_pay_status_name;//平台费状态描述
@property(strong,nonatomic)NSString* pay_sn;//平台费支付流水号
@property(assign,nonatomic)XYAllOrderType type;


//屏幕折旧相关 分为回收配件 和 不回收配件 两种情况，两种情况只能选一种
@property(assign,nonatomic)BOOL is_extra;//要不要显示屏幕折旧     完成前状态
@property(assign,nonatomic)NSInteger extraPrice;// b = a - c 的c  维修完成后

@property(strong,nonatomic)NSString* extraMes;//折旧描述文案
@property(assign,nonatomic)NSInteger extraPrices;// a = b + c 的c 完成前状态
@property(assign,nonatomic)BOOL allowExtraPrice;//打勾没打勾  维修完成后

@property(strong,nonatomic)NSString* extraMes_noRecyle;//折旧描述文案_不回收配件
@property(assign,nonatomic)NSInteger extraPrices_noRecyle;// a = b + c 的c 完成前状态 _不回收配件
@property(assign,nonatomic)BOOL allowExtraPrice_noRecyle;//打勾没打勾_不回收配件  维修完成后

//零件相关
@property(assign,nonatomic)BOOL bill_type;
@property(strong,nonatomic)NSString* partName;
@property(strong,nonatomic)NSString* partNumber;
@property(assign,nonatomic)CGFloat external_price;
//保修期及分项收费
@property(assign,nonatomic)BOOL need_pay_status;//是否需要展示保内/外选项
@property(assign,nonatomic)XYGuarrantyStatus brand_warranty_status;//保内/外
@property(assign,nonatomic)NSInteger repairprice;
@property(assign,nonatomic)NSInteger brand_home_visit_fee;
@property(assign,nonatomic)NSInteger brand_manual_fee;
//魅族
@property(strong,nonatomic)NSString* rp_id;//维修方案id字符串（joined by ','）
@property(strong,nonatomic)NSString* vip;
@property(copy,nonatomic)NSString* vip_name;//企业&高校名


//formatString
@property(strong,nonatomic)NSString* createTimeString;
@property(strong,nonatomic)NSString* wareHouseString;
@end

@interface XYPHPCommentDetail : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* Content;
@property(assign,nonatomic)NSInteger status;
@property(copy,nonatomic)NSString* CreateTime;
@property(assign,nonatomic)NSInteger grade;
@end

@interface XYPHPReplyDetail : NSObject
@property(copy,nonatomic)NSString* ReplyContent;
@property(copy,nonatomic)NSString* CreateTime;
@end

@interface XYPHPCommentDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)XYPHPCommentDetail* comment;
@property(strong,nonatomic)XYPHPReplyDetail* reply;
@property(copy,nonatomic)NSString* message;
@property(copy,nonatomic)NSString* mes;

@property(assign,nonatomic)NSInteger stars;
@property(copy,nonatomic)NSString* commentTime;
@property(copy,nonatomic)NSString* replyTime;
@end

@interface XYPayServiceCode : NSObject
@property(copy,nonatomic)NSString* code_url;
@property(copy,nonatomic)NSString* price;
@end

@interface XYOrderCount : NSObject
@property(assign,nonatomic)NSInteger in_complete;
@property(assign,nonatomic)NSInteger complete;
@property(assign,nonatomic)NSInteger clearing;
@end

@interface XYRemindInfo : NSObject
@property(assign,nonatomic)BOOL status;
@property(copy,nonatomic)NSString* info;
@end

@interface XYOrderMessageDto : NSObject
@property(strong,nonatomic)NSString* u_mobile;
@property(strong,nonatomic)NSString* order_id;
@property(strong,nonatomic)NSString* engineer_id;
@property(strong,nonatomic)NSString* e_mobile;
@end

@interface XYRemindOrderDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)XYOrderMessageDto* data;
@property(copy,nonatomic)NSString* mes;
@property(strong,nonatomic)XYRemindInfo* remind;
@end

//已取消订单
@interface XYCancelOrderDto : NSObject
@property (strong,nonatomic) NSString* order_id; //非魅族普通订单之订单号
@property (strong,nonatomic) NSString* order_num;//魅族专享订单号。。。
@property (assign,nonatomic) XYBrandType bid;
@property (strong,nonatomic) NSString* mould;
@property (strong,nonatomic) NSString* user_name;
@property (strong,nonatomic) NSString* fault;
@property (assign,nonatomic) BOOL isVip;//企业服务
@end

@interface XYCancelOrderListDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)NSArray* day;
@property(strong,nonatomic)NSArray* data;
@property(copy,nonatomic)NSString* mes;
@end

//维修选项（点击“维修完成”后的界面里的各种是否选项，写死）
@interface XYRepairSelections : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* order_id;
@property(copy,nonatomic)NSString* is_fixed;
@property(copy,nonatomic)NSString* is_miss;
@property(copy,nonatomic)NSString* is_wet;
@property(copy,nonatomic)NSString* is_deformed;
@property(copy,nonatomic)NSString* is_recycle;
@property(copy,nonatomic)NSString* is_used;
@property(copy,nonatomic)NSString* is_normal;
+ (NSArray*)repairSelectionTitlesArray;
+ (NSArray*)repairSelectionParamsArray;
@end

//颜色选项（用于维修订单下单流程）
@interface XYColorDto : NSObject
@property(copy,nonatomic)NSString* ColorId;
@property(copy,nonatomic)NSString* ColorName;
@end



