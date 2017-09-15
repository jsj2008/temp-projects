//
//  XYAPIService+UserAPI.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService+V2API.h"

static NSString* const EDIT_PART_SOURCE = @"order/parts-souce";//修改零件来源价格
static NSString* const MY_PARTS = @"parts/list";//我的配件列表
static NSString* const PARTS_RECORD = @"parts/record";//我的领取列表
static NSString* const CONFIRM_RECORD = @"parts/confirm";//确认领取
static NSString* const VERSION_UPDATE = @"fault/update";//版本更新
static NSString* const PAY_AVAILABILITY = @"features/list";//支付方式可用性

@implementation XYAPIService (V2API)

- (NSInteger)doEditPartSource:(NSString*)orderId house:(BOOL)isOutWareHouse price:(NSInteger)money success:(void (^)())success errorString:(void (^)(NSString *))errorString{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(isOutWareHouse) forKey:@"house"];
    [parameters setValue:@(money) forKey:@"money"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_PART_SOURCE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            errorString(dto.mes);
        }
    }failure:^(NSString *error){
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (NSInteger)getMyPartsList:(void (^)(NSArray* partsList))success errorString:(void (^)(NSString *))errorString{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:MY_PARTS parameters:nil isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPartDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (NSInteger)getClaimRecordsList:(NSInteger)p success:(void (^)(NSArray* recordsList,NSInteger sum))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(p) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PARTS_RECORD parameters:parameters isPost:false success:^(id response) {
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSMutableArray* array = [[NSMutableArray alloc]initWithArray:[XYPartRecordDto mj_objectArrayWithKeyValuesArray:listDto.data]];
            for (XYPartRecordDto* partRecord in array) {
                NSArray* parts = [XYPartDto mj_objectArrayWithKeyValuesArray:partRecord.parts];
                partRecord.parts = parts;
            }
            success(array,listDto.info.sum);
        }else{
            errorString(listDto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}


- (NSInteger)confirmClaiming:(NSString*)claimId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:claimId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CONFIRM_RECORD parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            errorString(dto.mes);
        }
    }failure:^(NSString *error){
        errorString?errorString(error):nil;
    }];
    return requestId;
}

- (void)getVersionUpdate:(NSString*)build success:(void (^)(NSString* version, NSString* desc, NSString* appId))success errorString:(void (^)(NSString *))errorString {
    [[XYHttpClient sharedInstance]requestPath:VERSION_UPDATE parameters:nil isPost:false success:^(id response) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS) {
            XYVersionDto* v = [XYVersionDto mj_objectWithKeyValues:dto.data];
            success(v.version,v.desc,v.AppId);
        }else{
            errorString?errorString(@""):nil;
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
}

//- (NSInteger)getCashPayAvailability:(void (^)(BOOL isOpen))success errorString:(void (^)(NSString *))errorString{
//
//    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:FEATURE_AVAILABILITY parameters:nil isPost:false success:^(id response){
//        XYSingleArrayDto* dto = [XYSingleArrayDto objectWithKeyValues:response];
//        if (dto.code == RESPONSE_SUCCESS){
//            NSArray* featuresArray = [XYFeatureDto objectArrayWithKeyValuesArray:dto.data];
//            BOOL cashFeatureFound = false;
//            for (XYFeatureDto* feature in featuresArray) {
//                if ([feature.node_name isEqualToString:@"cash-pay"]) {
//                    success((feature.is_open == XYFeatureStatusOpen));
//                    break;
//                }
//            }
//            if (!cashFeatureFound) {
//                errorString(@"未获得现金支付开关信息");
//            }
//        }else{
//            errorString(dto.mes);
//        }
//    }failure:^(NSString *error){
//        errorString?errorString(error):nil;
//    }];
//    return requestId;
//}

- (NSInteger)getPayOpenList:(void (^)(NSArray<XYFeatureDto*>* openList))success errorString:(void (^)(NSString *))errorString{
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PAY_AVAILABILITY parameters:nil isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* featuresArray = [XYFeatureDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(featuresArray);
        }else{
            errorString(dto.mes);
        }
    }failure:^(NSString *error){
        errorString?errorString(error):nil;
    }];
    return requestId;
}

@end
