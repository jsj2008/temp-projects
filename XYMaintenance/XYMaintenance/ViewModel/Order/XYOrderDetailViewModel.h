//
//  XYOrderDetailViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

//section 分组原则 0.顶栏 1.用户信息 2.机型信息 3.维修信息 4.保修信息 5.其他信息 6.付款码 7.评论
typedef NS_ENUM(NSInteger, XYOrderDetailSectionType) {
    XYOrderDetailSectionTypeTop = 0,
    XYOrderDetailSectionTypeUserInfo = 1,
    XYOrderDetailSectionTypeDeviceInfo = 2,
    XYOrderDetailSectionTypeRepairInfo = 3,
    XYOrderDetailSectionTypePricesAndGuarantee = 4,
    XYOrderDetailSectionTypeOthers = 5,
    XYOrderDetailSectionTypeQRCode = 6,
    XYOrderDetailSectionTypeComment = 7,
};

typedef NS_ENUM(NSInteger, XYOrderDetailCellType) {
    XYOrderDetailCellTypeTop = 0,       //顶栏
    XYOrderDetailCellTypeCancelRemark = 1, //审核备注
    XYOrderDetailCellTypeName = 10,    // 姓名
    XYOrderDetailCellTypePhone = 11,    // 电话
    XYOrderDetailCellTypeAddress = 12, //地址
    XYOrderDetailCellTypeRepairTime = 13,//预约时间
    XYOrderDetailCellTypeVIPType = 14,//订单类型（是否是企业服务vip）
    XYOrderDetailCellTypeVIPName = 15,//企业&高校名称
    XYOrderDetailCellTypeDevice = 20,//设备型号颜色
    XYOrderDetailCellTypeColor = 21,//颜色
    //section345 非魅族订单
    XYOrderDetailCellTypeFault = 30,
    XYOrderDetailCellTypePlan = 31,
    XYOrderDetailCellTypeOtherFaults = 32,
    XYOrderDetailCellTypeOtherFaults_noRecyle = 33,
    XYOrderDetailCellTypeTotalPrice = 40,
    XYOrderDetailCellTypePaymentName = 41,//支付类型
    XYOrderDetailCellTypeRepairPrice = 42,//维修费
    XYOrderDetailCellTypeHomeServicePrice = 43,//上门费
    XYOrderDetailCellTypeWorkerPrice = 44,//手工
    XYOrderDetailCellTypeGuarantee = 45,//保内/外
    XYOrderDetailCellTypeUserRemark = 50,
    XYOrderDetailCellTypeInternalRemark = 51,//内部备注
    XYOrderDetailCellTypeSerialNumber = 52,
    XYOrderDetailCellTypeDevicePhoto = 53,
    XYOrderDetailCellTypeEngineerRemark = 54,
    XYOrderDetailCellTypePlatformFee = 55,
    XYOrderDetailCellTypeAlipaySerialNumber = 56,
    XYOrderDetailCellTypeSettleStatus = 57,
    

    //section345 对魅族订单单独处理
    XYOrderDetailCellTypeMeizuFaults = 300,//魅族故障
    XYOrderDetailCellTypeMeizuSNCode = 301,//魅族sn
    XYOrderDetailCellTypeMeizuVIPCode = 302,//魅族vip
    XYOrderDetailCellTypeMeizuOtherFaults = 303,//魅族其它故障。。？可能没有
    XYOrderDetailCellTypeMeizuGuarantee = 400,//保修状态：字符串
    XYOrderDetailCellTypeMeizuHomeServicePrice = 401,//上门费
    XYOrderDetailCellTypeMeizuRepairPrice = 402,//维修费
    XYOrderDetailCellTypeMeizuWorkerPrice = 403,//手工费
    XYOrderDetailCellTypeMeizuTotalPrice = 404,//总价
    XYOrderDetailCellTypeMeizuPaymentName  = 405,//支付类型
    XYOrderDetailCellTypeMeizuUserRemark = 500,
    XYOrderDetailCellTypeMeizuInternalRemark = 501,
    XYOrderDetailCellTypeMeizuPhotos = 502,
    XYOrderDetailCellTypeMeizuEngineerRemark = 503,
    XYOrderDetailCellTypeMeizuSettleStatus = 504,
    
    XYOrderDetailCellTypePayQRCode = 60,
    XYOrderDetailCellTypeComment = 70,
};

@protocol XYOrderDetailCallBackDelegate <NSObject>

- (void)onOrderDetailLoaded:(BOOL)success noteString:(NSString*)str;
- (void)onOrderCommentLoaded:(BOOL)success noteString:(NSString*)str;
- (void)onDeviceSerialNumberEdited:(BOOL)success noteString:(NSString*)str;
- (void)onVIPCodeEdited:(BOOL)success noteString:(NSString*)str;
- (void)onPreOrderTimeEdited:(BOOL)success noteString:(NSString*)str;
- (void)onRepairPlanEdited:(BOOL)success noteString:(NSString*)str;
- (void)onOrderStatusChangedInto:(XYOrderStatus)status;
- (void)onOrderStatusChangingFailed:(NSString*)error;
- (void)onOrderPaidByCash:(BOOL)success noteString:(NSString*)str;
- (void)onRemarkEdited:(BOOL)success noteString:(NSString*)str;
- (void)onGuarranteeEdited:(BOOL)success noteString:(NSString*)str;
- (void)onPayQRCodeLoaded:(BOOL)success type:(XYQRCodePayType)type code:(NSString*)code price:(NSString*)price noteString:(NSString*)str;

@end

@interface XYOrderDetailViewModel : XYBaseViewModel

@property(strong,nonatomic) XYOrderDetail* orderDetail;
@property(strong,nonatomic) XYPHPCommentDto* comment;
@property(assign,nonatomic) id<XYOrderDetailCallBackDelegate> delegate;
@property(strong,nonatomic) NSMutableDictionary* titleMap;
@property(strong,nonatomic) NSMutableDictionary* contentMap;
@property(strong,nonatomic) NSMutableDictionary* cachedPhotoMap;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (XYOrderDetailCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByType:(XYOrderDetailCellType)type;
- (NSString*)getContentByType:(XYOrderDetailCellType)type;
- (BOOL)getInputableByType:(XYOrderDetailCellType)type;
- (BOOL)getSelectableByType:(XYOrderDetailCellType)type;

- (BOOL)canScanQRCode;//是否可以显示二维码
- (BOOL)shouldShowOtherFaults;//是否要显示额外选项
- (BOOL)isBeforeRepairingDone;//是否维修完成
- (BOOL)shouldShowRepairSelections;//是否要显示维修信息
- (BOOL)hasCancelCheckRemark;//是否要显示取消审核备注
- (BOOL)isMeizuOrder;//是否是魅族订单
- (BOOL)allPhotosTaken;//照片是否都已经拍摄（已上传成功：存在url 未上传成功：必须存在本地图片）

- (void)loadOrderDetail:(NSString*)orderId bid:(XYBrandType)bid;
- (void)loadUserComment:(NSString*)orderId;
- (void)editDeviceSerialNumberInto:(NSString*)devNo;
- (void)editVipCodeInto:(NSString*)vip;
- (void)editRepairOrderedTime:(NSString*)reservetime reservetime2:(NSString *)reservetime2;
- (void)editRepairPlanInto:(NSString*)planid device:(NSString*)mouldId color:(NSString*)color;
- (void)turnStateOfOrderInto:(XYOrderStatus)status;
- (void)payOrderByCash;
- (void)getPayCode:(XYQRCodePayType)type;
- (void)editRemarkInto:(NSString*)str;
- (void)editGuarranteeInto:(XYGuarrantyStatus)status;
- (void)addOrDeleteRepairPlan:(NSString*)planId device:(NSString*)deviceId color:(NSString*)colorId isAddOrDelete:(BOOL)isAdd;
//循环刷新支付状态
- (void)checkPaymentStatusRepeatedly;
//照片相关
@property(assign,nonatomic) BOOL hasTakenSelfPhoto;//是否已经自拍过
- (BOOL)getPhotoTakingAvailable;
- (BOOL)getPhotoSavingAvailable;
//上传异步照片
- (void)uploadAsynPhoto:(NSData*)imgData type:(XYPictureType)type repeatCount:(NSInteger)count orderId:(NSString*)orderId bid:(XYBrandType)bid name:(NSString*)name onSuccess:(void (^)(NSString*))success onFailure:(void (^)())onFailure;
@end
