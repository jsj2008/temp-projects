//
//  XYPayUtil.h
//  XYMaintenance
//
//  Created by Kingnet on 16/3/17.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "WXApiObject.h"

@interface XYPayUtil : NSObject

//微信支付
- (void)wechatPayWithOrderId:(NSString *)orderId info:(NSString *)info price:(NSInteger)price success:(void (^)())success failure:(void(^)(NSString *error))failure;

//支付宝
- (void)alipayWithOrderId:(NSString *)orderId success:(void (^)())successpay failure:(void(^)(NSString *error))failure;

//支付宝平台费
- (void)alipayPlatformfeeWithId_str:(NSString *)id_str success:(void (^)())successpay failure:(void(^)(NSString *error))failure;

@end
