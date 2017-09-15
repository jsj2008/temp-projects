//
//  XYAPPDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDtoContainer.h"


@interface XYLocDtoContainer : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)NSInteger data;
@end

@interface XYPHPDeviceDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* ProductId;
@property(copy,nonatomic)NSString* BrandId;
@property(copy,nonatomic)NSString* MouldName;
@property(copy,nonatomic)NSString* Colors;
@property(assign,nonatomic)XYBrandType bid;
@property(copy,nonatomic)NSString* ProductName;
@property(copy,nonatomic)NSString* BrandName;
@end

@interface XYLabelDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* Name;
@end

@interface XYNoticeDto : NSObject
@property(copy,nonatomic)NSString* title;
@property(copy,nonatomic)NSString* detail;
@property(copy,nonatomic)NSString* time;
@property(copy,nonatomic)NSString* orderId;
@end

@interface XYContactDto : NSObject
@property(copy,nonatomic)NSString* avatarUrl;
@property(copy,nonatomic)NSString* name;
@property(copy,nonatomic)NSString* capital;
@property(copy,nonatomic)NSString* phone;
@end

@interface XYVersionDto : NSObject
@property (nonatomic,copy) NSString *img;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *AppId;
@property (nonatomic,copy) NSString *version;
@end

@interface XYPlanDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* fault_name;
@property(copy,nonatomic)NSString* RepairType;
@property(copy,nonatomic)NSString* Price;
@property(assign,nonatomic)CGFloat cellHeight;
@end


@interface XYAgreementDto : NSObject
@property(copy,nonatomic)NSString* url;
@property(assign,nonatomic)BOOL agreement;
@property(assign,nonatomic)XYBrandType bid;
@end




//typedef NS_ENUM(NSInteger, XYPayFeatureNode) {
//    XYPayFeatureNodeUnknown = 0,   //未知
//    XYPayFeatureNodeCash = 1,      //现金
//    XYPayFeatureNodeQRCodeWechat = 2,    //微信扫码
//    XYPayFeatureNodeQRCodeAlipay = 3,    //支付宝扫码
//    XYPayFeatureNodeWorkerPayWechat = 4, //weixin代付
//    XYPayFeatureNodeWorkerPayAlipay = 5, //支付宝代付
//};

