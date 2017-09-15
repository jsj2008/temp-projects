//
//  XYPayUtil.m
//  XYMaintenance
//
//  Created by Kingnet on 16/3/17.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPayUtil.h"
#import "DTO.h"
#import "MJExtension.h"
#import "XYHttpClient.h"
#import "XYAPPSingleton.h"
#import <AFNetworking/AFNetworking.h>
#import "XYConfig.h"
#import "XYStrings.h"
#import "XYStringUtil.h"

static NSString* const ALIPAY_WORKER = @"pay/anotherpayalipay";//支付宝
static NSString* const ALIPAY_PlATFORM_WORKER = @"pay/anotherpayalipay-payplatform";//支付宝
static NSString* const WECHAT_WORKER = @"pay/anotherpayweixin";//wechat

@implementation XYPayUtil

- (void)alipayWithOrderId:(NSString *)orderId success:(void (^)())successpay failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    
    [[XYHttpClient sharedInstance] requestPath:ALIPAY_WORKER parameters:parameters isPost:false success:^(id response) {
        
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS) {
            NSDictionary* data = dto.data;
            NSString* orderSpec = data[@"order_str"];
            NSString* signedString = data[@"sign_str"];
            NSString* orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderSpec,[self urlEncodedString:signedString] , @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:[XYAPPSingleton sharedInstance].appScheme callback:^(NSDictionary *resultDic) {
                TTDEBUGLOG(@"result = %@",resultDic);
                NSString* resultStatus = resultDic[@"resultStatus"];
                NSString* memo = resultDic[@"memo"];
                if ([resultStatus isEqualToString:@"9000"]){
                    successpay();
                }else{
                    failure(memo);
                }
            }];
        }else{
           failure(dto.mes);
        }
    } failure:^(NSString *error) {
        failure(TT_NETWORK_ERROR);
    }];
}

- (void)alipayPlatformfeeWithId_str:(NSString *)id_str success:(void (^)())successpay failure:(void(^)(NSString *error))failure{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:id_str forKey:@"id_str"];
    
    [[XYHttpClient sharedInstance] requestPath:ALIPAY_PlATFORM_WORKER parameters:parameters isPost:false success:^(id response) {
        
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS) {
            NSDictionary* data = dto.data;
            NSString* orderSpec = data[@"order_str"];
            NSString* signedString = data[@"sign_str"];
            NSString* orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                                     orderSpec,[self urlEncodedString:signedString] , @"RSA"];
            
            [[AlipaySDK defaultService] payOrder:orderString fromScheme:[XYAPPSingleton sharedInstance].appScheme callback:^(NSDictionary *resultDic) {
                TTDEBUGLOG(@"result = %@",resultDic);
                NSString* resultStatus = resultDic[@"resultStatus"];
                NSString* memo = resultDic[@"memo"];
//                NSString* result = resultDic[@"result"];
                //
//                NSString *tradeNumber;
//                if (![XYStringUtil isNullOrEmpty:result]) {
//                    NSRange range1 = [result rangeOfString:@"&out_trade_no="];
//                    NSLog(@"range1-%@", NSStringFromRange(range1));
//                    NSRange range2 = [result rangeOfString:@"&subject"];
//                    NSLog(@"range2-%@", NSStringFromRange(range2));
//                    NSRange subRange = NSMakeRange(range1.location+range1.length+1, range2.location-(range1.location+range1.length+1)-1);
//                    tradeNumber = [result substringWithRange:subRange];
//                    NSLog(@"resulthhh-%@", tradeNumber);
//                }
                //
                if ([resultStatus isEqualToString:@"9000"]){
                    successpay();
                }else{
                    failure(memo);
                }
            }];
        }else{
            failure(dto.mes);
        }
    } failure:^(NSString *error) {
        failure(TT_NETWORK_ERROR);
    }];
}

//20170413171301472197
- (void)wechatPayWithOrderId:(NSString *)orderId info:(NSString *)info price:(NSInteger)price success:(void (^)())successpay failure:(void(^)(NSString *error))failure{
    
    if (![WXApi isWXAppInstalled]) {
        failure(@"您的手机没有安装微信客户端,无法完成支付");
        return;
    }

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    
    [[XYHttpClient sharedInstance] requestPath:WECHAT_WORKER parameters:parameters isPost:false success:^(id response) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS) {
            NSDictionary* dict = dto.data;
            TTDEBUGLOG(@"%@",dict);
            //调起微信支付            
            PayReq* req             = [[PayReq alloc] init];
            req.openID              = [dict objectForKey:@"appid"];
            req.partnerId           = [dict objectForKey:@"partnerid"];
            req.prepayId            = [dict objectForKey:@"prepayid"];
            req.nonceStr            = [dict objectForKey:@"noncestr"];
            NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
            req.timeStamp           = stamp.intValue;
            req.package             = [dict objectForKey:@"package"];
            req.sign                = [dict objectForKey:@"sign"];
            [WXApi sendReq:req];
            successpay();
        }else{
            failure(dto.mes);
        }
    }failure:^(NSString *error) {
        failure(TT_NETWORK_ERROR);
    }];
}
     
- (void)onResp:(BaseResp*)resp{
    TTDEBUGLOG(@"XYPayUtil resp = %@",resp.errStr);
}

#pragma mark - Util

- (NSString*)urlEncodedString:(NSString *)string{
    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
    return encodedString;
}

@end
