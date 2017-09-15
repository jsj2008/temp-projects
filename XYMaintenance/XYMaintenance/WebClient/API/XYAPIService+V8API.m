//
//  XYAPIService+V8API.m
//  XYMaintenance
//
//  Created by Kingnet on 16/10/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService+V8API.h"

static NSString* const OVERTIME_ORDER = @"order/overtime";//超时订单（地图）
static NSString* const EDIT_GUARRANTEE = @"order/edit-order";//修改保内外状态
static NSString* const EDIT_RECEIPT = @"order/upload-receipt-pic";//发票照片
static NSString* const EDIT_MEIZU_PLAN = @"order/set-weixiudetail-fault";//魅族增删故障
static NSString* const EDIT_MEIZU_VIP = @"order/set-vip-code";//魅族vip码
static NSString* const EDIT_WECHAT_IMG = @"order/update-order-weixinpromotionimg";//微信推广照片
static NSString* const USER_VERIFY_CODE = @"order/send-valid-code";//向用户手机发送验证码（创建订单）
static NSString* const PROMOTION_RANKING = @"order/get-promotion-ranking";//地推排行榜

@implementation XYAPIService (V8API)

- (NSInteger)getOverTimeMapOrderList:(NSInteger)page success:(void (^)(NSArray* orderList))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(page) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:OVERTIME_ORDER parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* listDto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYOrderBase mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)changeGuarranteeStatusOfOrder:(NSString*)orderId into:(XYGuarrantyStatus)brand_warranty_status success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(brand_warranty_status) forKey:@"brand_warranty_status"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_GUARRANTEE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)editReceiptOfOrder:(NSString*)orderId
                         bid:(XYBrandType)bid
                         url:(NSString*)receipt_pic
                     success:(void (^)())success
                 errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    [parameters setValue:receipt_pic forKey:@"receipt_pic"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_RECEIPT parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)editMeizuPlansOfOrder:(NSString*)orderId
                             plans:(NSString*)planid
                            device:(NSString*)mould
                             color:(NSString *)color
                           success:(void (^)())success
                       errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:planid forKey:@"planid"];
    [parameters setValue:mould forKey:@"mould"];
     [parameters setValue:color forKey:@"color"];
 
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_MEIZU_PLAN parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
    
}

- (NSInteger)editVIPCodeInto:(NSString*)vip ofOrder:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:vip forKey:@"vip"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_MEIZU_VIP parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)addWechatPromotionPhoto:(NSString*)weixin_promotion_img
                               order:(NSString*)oid
                                 bid:(XYBrandType)bid
                             success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:oid forKey:@"oid"];
    [parameters setValue:weixin_promotion_img forKey:@"weixin_promotion_img"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_WECHAT_IMG parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)sendVerifyCodeToUserPhone:(NSString*)phoneNum success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:phoneNum forKey:@"phoneNum"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:USER_VERIFY_CODE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;

}

- (NSInteger)getPromotionRankList:(NSInteger)p type:(XYRankingListType)type success:(void (^)(XYPromotionRankDto* myRank, NSArray* newsList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(p) forKey:@"p"];
    
    NSString* typeStr = nil;
    switch (type) {
        case XYRankingListTypePromotionCity:
            typeStr = @"city";
            break;
        case XYRankingListTypePromotionPerson:
            typeStr = @"personal";
            break;
        default:
            break;
    }
    [parameters setValue:typeStr forKey:@"type"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PROMOTION_RANKING parameters:parameters isPost:false success:^(id response){
        XYPromotionRankListDataDto* listDto = [XYPromotionRankListDataDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            XYPromotionRankListDto* rankList = [XYPromotionRankListDto mj_objectWithKeyValues:listDto.data];
            NSArray* allArray = [XYPromotionRankDto mj_objectArrayWithKeyValuesArray:rankList.datas];
            rankList.datas = allArray;
            success(rankList.my_data,rankList.datas,rankList.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

@end
