//
//  XYAPIService+V1API.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService+V1API.h"
#import "XYConfig.h"

static NSString* const DELETE_ORDER = @"order/delete-order";//删除订单
static NSString* const COMPLETE_ORDER = @"order/complete-order";//完成订单
static NSString* const SHOP_REPAIR = @"order/shoprepair";//门店维修
static NSString* const SET_OUT = @"order/set-out-order"; //出发
static NSString* const CANCEL_ORDER = @"order/cancel-order";//取消订单
static NSString* const PAY_CASH = @"order/cash-pay";//现金支付
static NSString* const PAY_WECHAT = @"pay/qrcode";//微信支付
static NSString* const PAY_ALIPAY = @"pay/qrcodealipay";//支付宝 
static NSString* const EDIT_DEVNO = @"order/devno";//修改设备序列号
static NSString* const EDIT_REMARK = @"order/self-remark";//修改维修工备注
static NSString* const ORDER_DETAIL = @"order/detail";//订单详情
static NSString* const ADD_ORDER = @"order/create-order";//创建订单
static NSString* const SEARCH_ORDER = @"order/search";//搜索订单
static NSString* const EDIT_ORDER_TIME = @"order/reserve-time";//修改预约时间
static NSString* const EDIT_REPAIR_PLAN = @"order/plan";//修改维修方案
static NSString* const GET_COMMENT = @"comment/content";//获取评论
static NSString* const UPLOAD_POS = @"activities/location-temp";
static NSString* const TFC_DAILY_ORDER = @"order/day-complete";//每日订单
static NSString* const TFC_EDIT_ROUTES = @"fare/deal";//路线上报
static NSString* const TFC_DAILY_DATA = @"fare/day-count";//按日查询
static NSString* const TFC_MONTHLY_DATA = @"fare/month-list";//按月查询
static NSString* const TFC_DAILY_ROUTES = @"fare/day-list";//日路线记录
static NSString* const NEW_ORDER_LIST = @"order/incomplete";//已预约维修订单(地图)
static NSString* const OLD_ORDER_LIST = @"order/complete";//未完成订单
static NSString* const ALL_DEVICES = @"moiblemould/all-mould";//所有手机型号
static NSString* const ALL_FAULTS = @"fault/mould-fault"; //所有故障类型
static NSString* const DEVICE_COLOR = @"colors/get-colors";//新版设备颜色
static NSString* const REPAIR_PLANS = @"repairprice/get-repairce";//新版维修方案
static NSString* const CITY_LIST = @"region/city-list";//城市列表
static NSString* const DISTRICT_LIST = @"region/area-list";//区域列表

@implementation XYAPIService (V1API)

- (NSInteger)getTodayMapOrderList:(NSInteger)page success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(page) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:NEW_ORDER_LIST parameters:parameters isPost:false success:^(id response){
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYOrderBase mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getAllDevicesType:(XYOrderDeviceType)type success:(void (^)(NSDictionary* deviceDic))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(type) forKey:@"type"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ALL_DEVICES parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            for (NSString* key in [dto.data allKeys]){
                 NSArray* array = [XYPHPDeviceDto mj_objectArrayWithKeyValuesArray:[dto.data objectForKey:key]];
                 [dic setValue:array forKey:key];
            }
            success(dic);
        }else{
            error(dto.mes);
        }
     }failure:^(NSString *errorString){
        error?error(errorString):nil;
     }];
    return requestId;
}

- (NSInteger)getColorByDeviceId:(NSString*)mould_id
                          fault:(NSString*)fault_id
                            bid:(XYBrandType)bid
                        success:(void (^)(NSArray* colorArray))success
                    errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:mould_id forKey:@"mould_id"];
    [parameters setValue:fault_id forKey:@"fault_id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:DEVICE_COLOR parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYColorDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getAllFaultsType:(XYOrderType)order_status success:(void (^)(NSArray* faultArray))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(order_status) forKey:@"order_status"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ALL_FAULTS parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYLabelDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getRepairingPlanOfDevice:(NSString*)mould_id
                                fault:(NSString*)fault_id
                                color:(NSString*)color_id
                          orderStatus:(XYOrderType)order_status
                              success:(void (^)(NSArray* planArray))success
                          errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:mould_id forKey:@"mould_id"];
    [parameters setValue:fault_id forKey:@"fault_id"];
    [parameters setValue:color_id forKey:@"color_id"];
    [parameters setValue:@(order_status) forKey:@"order_status"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:REPAIR_PLANS parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPlanDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
   }failure:^(NSString *errorString){
        error?error(errorString):nil;
   }];
    
    return requestId;
}

- (NSInteger)getCityList:(void (^)(NSDictionary* citiesArray))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CITY_LIST parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            success(dto.data);
        }else{
            error(dto.mes);
        }
   }failure:^(NSString *errorString){
        error?error(errorString):nil;
   }];
   return requestId;
}

- (NSInteger)getDistrictList:(NSString*)cityId success:(void (^)(NSDictionary* districtsArray))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:cityId forKey:@"id"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:DISTRICT_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            success(dto.data);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)changeStatusOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSString* path = nil;
    switch (status){
        case XYOrderStatusDeleted:
            path = DELETE_ORDER;
            break;
        case XYOrderStatusRepaired:
        case XYOrderStatusDone:
            path = COMPLETE_ORDER;
            break;
        case XYOrderStatusShopRepairing:
            path = SHOP_REPAIR;
            break;
        case XYOrderStatusOnTheWay:
            path = SET_OUT;
        default:
            break;
    }
    
    if (!path) {
        error(@"订单状态错误！");
        return -1;
    }
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:path parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)cancelOrder:(NSString*)orderId reason:(NSString*)reasonId remark:(NSString*)remark bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:reasonId forKey:@"reason"];
    [parameters setValue:remark forKey:@"remark"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CANCEL_ORDER parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)setOutOrder:(NSString*)orderId bid:(XYBrandType)bid address:(NSString*)address lat:(NSString*)lat lng:(NSString*)lng success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    [parameters setValue:address forKey:@"address"];
    [parameters setValue:lat forKey:@"lat"];
    [parameters setValue:lng forKey:@"lng"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:SET_OUT parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)completeOrder:(NSString*)orderId
                       bid:(XYBrandType)bid
           withOtherFaults:(BOOL)hasFaults
           withOtherFaults_noRecyle:(BOOL)hasFaults_noRecyle
                  is_fixed:(NSInteger)is_fixed
                   is_miss:(NSInteger)is_miss
                    is_wet:(NSInteger)is_wet
               is_deformed:(NSInteger)is_deformed
                is_recycle:(NSInteger)is_recycle
                   is_used:(NSInteger)is_used
                 is_normal:(NSInteger)is_normal
                   address:(NSString*)address
                       lat:(NSString*)lat
                       lng:(NSString*)lng
                   success:(void (^)())success
               errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:hasFaults?@"YES":@"NO" forKey:@"allowExtraPrice"];
    [parameters setValue:hasFaults_noRecyle?@"YES":@"NO" forKey:@"allowExtraPrice_noRecyle"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    [parameters setValue:@(is_fixed) forKey:@"is_fixed"];
    [parameters setValue:@(is_miss) forKey:@"is_miss"];
    [parameters setValue:@(is_wet) forKey:@"is_wet"];
    [parameters setValue:@(is_deformed) forKey:@"is_deformed"];
    [parameters setValue:@(is_recycle) forKey:@"is_recycle"];
    [parameters setValue:@(is_used) forKey:@"is_used"];
    [parameters setValue:@(is_normal) forKey:@"is_normal"];

    [parameters setValue:address forKey:@"address"];
    [parameters setValue:lat forKey:@"lat"];
    [parameters setValue:lng forKey:@"lng"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:COMPLETE_ORDER parameters:parameters isPost:false success:^(id response){
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


- (NSInteger)payOrderByCash:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PAY_CASH parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)payByService:(XYQRCodePayType)type order:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(NSString* imgUrl,NSString* price))success errorString:(void (^)(NSString *))error{
    
    NSString* path = nil;
    switch (type){
        case XYQRCodeCellTypeWechat:
            path = PAY_WECHAT;
            break;
        case XYQRCodeCellTypeAlipay:
            path = PAY_ALIPAY;
            break;
        default:
            break;
    }
    
    if (!path) {
        error(@"支付方式错误！");
        return -1;
    }
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:path parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYPayServiceCode* code = [XYPayServiceCode mj_objectWithKeyValues:dto.data];
            success(code.code_url,code.price);
        }else{
            error?error(@"获取二维码失败"):nil;
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)editDeviceSerialNumberInto:(NSString*)devno ofOrder:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:devno forKey:@"devno"];
    [parameters setValue:@(bid) forKey:@"bid"];

    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_DEVNO parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)editOrderTime:(NSString*)orderId newTime:(NSString*)reservetime reservetime2:(NSString*)reservetime2 bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:reservetime forKey:@"reservetime"];
    [parameters setValue:reservetime2 forKey:@"reservetime2"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_ORDER_TIME parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)editRepairingPlanOfOrder:(NSString*)orderId
                            newPlanId:(NSString*)planid
                              mouldId:(NSString*)mould
                                color:(NSString *)color
                                  bid:(XYBrandType)bid
                              success:(void (^)())success
                          errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:planid forKey:@"planid"];
    [parameters setValue:mould forKey:@"mould"];
    [parameters setValue:color forKey:@"color"];
    [parameters setValue:@(bid) forKey:@"bid"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_REPAIR_PLAN parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)editOrderRemark:(NSString*)orderId remark:(NSString*)content bid:(XYBrandType)bid success:(void (^)())success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:content forKey:@"content"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_REMARK parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)getOrderDetail:(NSString*)orderId type:(XYBrandType)bid success:(void (^)(XYOrderDetail* order))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ORDER_DETAIL parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYOrderDetail* orderDetail = [XYOrderDetail mj_objectWithKeyValues:dto.data];
            success(orderDetail);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getOrderComment:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYPHPCommentDto* order))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:GET_COMMENT parameters:parameters isPost:false success:^(id response){
        XYPHPCommentDto* dto = [XYPHPCommentDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success(dto);
        }else{
            error(dto.message);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)addOrderWithPlan:(NSString*)planId
                       device:(NSString*)moudleid
                      colorId:(NSString*)color
                        phone:(NSString*)mobile
                         user:(NSString*)name
                         city:(NSString*)cityid
                     district:(NSString*)areaid
                      address:(NSString*)address
                          lat:(CGFloat)lat
                          lng:(CGFloat)lng
                         code:(NSString*)validCode
                      success:(void (^)())success
                  errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:planId forKey:@"planid"];
    [parameters setValue:moudleid forKey:@"moudleid"];
    [parameters setValue:color forKey:@"color"];
    [parameters setValue:mobile forKey:@"mobile"];
    [parameters setValue:name forKey:@"name"];
    [parameters setValue:cityid forKey:@"cityid"];
    [parameters setValue:areaid forKey:@"areaid"];
    [parameters setValue:address forKey:@"address"];
    [parameters setValue:@(lat) forKey:@"lat"];
    [parameters setValue:@(lng) forKey:@"lng"];
    [parameters setValue:validCode forKey:@"validCode"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ADD_ORDER parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)searchOrderByKeyword:(NSString*)key success:(void (^)(NSArray* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:key forKey:@"key"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:SEARCH_ORDER parameters:parameters isPost:false success:^(id response){
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYOrderBase mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}



- (NSInteger)getDailyCompletedOrders:(NSString*)day success:(void (^)(NSArray* ordersArray))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:day forKey:@"day"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:TFC_DAILY_ORDER parameters:parameters isPost:false success:^(id response) {
        XYListDtoContainer* dto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYTrafficOrderLocDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    
    return requestId;
}

/**
 *  上报交通费 post
 *
 *  @param date      yyyy-mm-dd
 *  @param data      postbody
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)postEditedDailyRoutesRecord:(NSString*)date body:(NSArray*)data success:(void (^)())success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:date forKey:@"date"];
    NSInteger requestId = [[XYHttpClient sharedInstance]postBody:TFC_EDIT_ROUTES body:data urlParameter:parameters success:^(id response) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success();
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString(error);
    }];
    return requestId;
}


/**
 *  获取每日交通费信息base
 *
 *  @param date      yyyy-mm-dd
 *  @param success 成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
-(NSInteger)getTFCDailyInfoOf:(NSString*)date success:(void (^)(XYTFCDailyInfo* info))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:date forKey:@"date"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:TFC_DAILY_DATA parameters:parameters isPost:false success:^(id response) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            XYTFCDailyInfo* info = [XYTFCDailyInfo mj_objectWithKeyValues:dto.data];
            success(info);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    
    return requestId;
    
}


- (NSInteger)getMonthlyInfoOf:(NSInteger)month year:(NSInteger)year success:(void (^)(XYTFCMonthlyInfo* info))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(month) forKey:@"month"];
    [parameters setValue:@(year) forKey:@"year"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:TFC_MONTHLY_DATA parameters:parameters isPost:false success:^(id response) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            XYTFCMonthlyInfo* monthlyInfo = [XYTFCMonthlyInfo mj_objectWithKeyValues:dto.data];
            NSArray* array = [XYMonthlyFeeDto mj_objectArrayWithKeyValuesArray:monthlyInfo.list];
            monthlyInfo.list = array;
            success(monthlyInfo);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}


- (NSInteger)getTFCDailyRouteOf:(NSString*)date success:(void (^)(NSArray* info))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:date forKey:@"date"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:TFC_DAILY_ROUTES parameters:parameters isPost:false success:^(id response) {
        XYListDtoContainer* dto = [XYListDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYTrafficRecordDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}


- (void)transferCoordinate:(CGFloat)lat and:(CGFloat)lng success:(void (^)(NSArray* locationArray))success errorString:(void (^)(NSString *))errorString{
    
    NSString* aMapRestApi = @"https://restapi.amap.com/v3/assistant/coordinate/convert";
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[NSString stringWithFormat:@"%.5f,%.5f",lng,lat] forKey:@"locations"];
    [parameters setValue:@"json" forKey:@"output"];
    [parameters setValue:@"gps" forKey:@"coordsys"];
    [parameters setValue:GAODE_REST_KEY forKey:@"key"];
    
    
    [[XYHttpClient sharedInstance]getRequestWithUrl:aMapRestApi parameters:parameters success:^(id response){
        XYAmapLocationDto* dto = [XYAmapLocationDto mj_objectWithKeyValues:response];
        if (dto.status == 1){
            NSArray* arr = [dto.locations componentsSeparatedByString:@","];
            success(arr);
        }else{
            errorString(nil);
        }
        
    } failure:^(NSString *error) {
        errorString(error);
    }];
    
    return;
}


//- (NSInteger)postCoordinate:(NSString*)lat and:(NSString*)lng success:(void (^)(NSInteger nextUpdate))success errorString:(void (^)(NSString *))error{
//    
//    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
//    [parameters setValue:lat forKey:@"latitude"];
//    [parameters setValue:lng forKey:@"longitude"];
//    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:UPLOAD_POS parameters:parameters isPost:false success:^(id response){
//        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
//        if (dto.code == RESPONSE_SUCCESS) {
//            success?success(0):nil;
//        }else{
//            error?error(@""):nil;
//        }
//    }failure:^(NSString *errorString){
//        error?error(errorString):nil;
//    }];
//    return requestId;
//}

- (NSInteger)postCoordinate:(NSString*)lat and:(NSString*)lng success:(void (^)(NSInteger nextUpdate))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:lat forKey:@"latitude"];
    [parameters setValue:lng forKey:@"longitude"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:UPLOAD_POS parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS) {
            success?success(0):nil;
        }else{
            error?error(@""):nil;
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}





@end

