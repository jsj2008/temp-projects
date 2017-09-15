//
//  XYPayDto.h
//  XYMaintenance
//
//  Created by Kingnet on 17/2/4.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDtoContainer.h"

//功能启用禁用情况
typedef NS_ENUM(NSInteger, XYFeatureStatus) {
    XYFeatureStatusOpen = 1,    //开启
    XYFeatureStatusClose = 2,    //关闭
};

@interface XYFeatureDto : NSObject
@property(copy,nonatomic)NSString* name;
@property(copy,nonatomic)NSString* node_name;
@property(assign,nonatomic)XYFeatureStatus is_open;//
@property(assign,nonatomic)XYBrandType brandid;

+ (void)save:(NSArray<XYFeatureDto*>*)features;
+ (NSArray<XYFeatureDto*>*)loadFeatures;
@end


//支付功能开关
@interface XYPayOpenModel : NSObject

@property(assign,nonatomic)BOOL cashpay;
@property(assign,nonatomic)BOOL qrcode;
@property(assign,nonatomic)BOOL qrcodealipay;
@property(assign,nonatomic)BOOL anotherpayweixin;
@property(assign,nonatomic)BOOL anotherpayalipay;
@property(assign,nonatomic)XYBrandType bid;

+ (XYPayOpenModel*)modelWithAllFalse;
+ (NSDictionary<NSString*,XYPayOpenModel*>*)convert:(NSArray<XYFeatureDto*>*)features;

@end

