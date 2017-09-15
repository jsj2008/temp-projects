//
//  XYAPIService+V6API.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/13.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService+V6API.h"

static NSString* const RECYCLE_DEVICES = @"shr/productdata";//回收机型
static NSString* const RECYCLE_SELECTION = @"shr/attrfaultlist";//回收选项
static NSString* const RECYCLE_PRICE = @"shr/get-estimate-price";//回收估价
static NSString* const RECYCLE_CREATE_ORDER = @"shr/create-order";//创建订单
static NSString* const RECYCLE_UPDATE_ORDER = @"shr/update-order";//更新订单
static NSString* const RECYCLE_SETOFF = @"shr/set-out-order";//出发
static NSString* const RECYCLE_ORDER_DETAIL = @"shr/order-detail";//订单详情

static NSString* const NEW_ALL_ORDER_LIST = @"order/incomplete160714";//未完成订单
static NSString* const OLD_ALL_ORDER_LIST = @"order/complete160714";//完成订单


static NSString* const CLEAR_ALL_ORDER_LIST = @"order/clearing160714";//已结算订单
static NSString* const ALL_CLEAR_ORDER_DATE = @"order/clearing-date";//有结算订单的日期

static NSString* const EDIT_REPAIR_PHOTOS = @"order/devnopic";//修改维修订单照片
static NSString* const RECYCLE_BONUS = @"order/shr-order-push-list";//回收提成
static NSString* const REPAIR_SELECTIONS = @"order/get-order-supplemnt-info";//维修选项
static NSString* const EDIT_SELF_PHOTO = @"order/update-orderfinishimg";//修改自拍照片

@implementation XYAPIService (V6API)

- (NSInteger)getRecycleDevicesList:(void (^)(NSDictionary* deviceDic))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RECYCLE_DEVICES parameters:nil isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            for (NSString* key in [dto.data allKeys]){
                NSArray* array = [XYRecycleDeviceDto mj_objectArrayWithKeyValuesArray:[dto.data objectForKey:key]];
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

- (NSInteger)getRecycleSelectionsList:(NSString*)mouldid success:(void (^)(NSArray* selectionsList))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:mouldid forKey:@"id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RECYCLE_SELECTION parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYRecycleSelectionsDto mj_objectArrayWithKeyValuesArray:dto.data];
            NSMutableArray* muteArray = [[NSMutableArray alloc]init];
            for (XYRecycleSelectionsDto* selection in array) {
                NSArray* itemsArray = [XYRecycleSelectionItem mj_objectArrayWithKeyValuesArray:selection.detail_info];
                selection.detail_info = itemsArray;
                [muteArray addObject:selection];
            }
            success(muteArray);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getEstimatePriceOfDevice:(NSString*)mouldid selections:(NSString*)attr success:(void (^)(NSInteger price))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:mouldid forKey:@"id"];
    [parameters setValue:attr forKey:@"attr"];//。。。
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RECYCLE_PRICE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success([dto.data[@"price"] integerValue]);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;

}

- (NSInteger)createOrUpdateRecycleOrder:(NSString*)orderId device:(NSString*)mould_id selections:(NSString*)attr price:(NSInteger)price serialNumber:(NSString*)device_sn remark:(NSString*)remark name:(NSString*)user_name phone:(NSString*)mobile identity:(NSString*)id_card province:(NSString*)province city:(NSString*)city area:(NSString*)district address:(NSString*)address signPic:(NSString*)sign_url payType:(XYRecyclePayType)payment_method account:(NSString*)account_number success:(void (^)(NSString* orderId))success errorString:(void (^)(NSString *))error{
 
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:mould_id forKey:@"mould_id"];
    [parameters setValue:attr forKey:@"attr"];
    [parameters setValue:@(price) forKey:@"price"];
    [parameters setValue:device_sn forKey:@"device_sn"];
    [parameters setValue:remark forKey:@"remark"];
    [parameters setValue:user_name forKey:@"user_name"];
    [parameters setValue:mobile forKey:@"mobile"];//注意，入参是mobile，返回的才是user_mobile
    [parameters setValue:id_card forKey:@"id_card"];
    [parameters setValue:province forKey:@"province"];
    [parameters setValue:city forKey:@"city"];
    [parameters setValue:district forKey:@"district"];
    [parameters setValue:address forKey:@"address"];
    [parameters setValue:sign_url forKey:@"sign_url"];
    [parameters setValue:@(payment_method) forKey:@"payment_method"];
    [parameters setValue:account_number forKey:@"account_number"];
    
    NSString* path = orderId?RECYCLE_UPDATE_ORDER:RECYCLE_CREATE_ORDER;//用orderId判断是否是新创建的订单
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:path parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            success(orderId?orderId:dto.data[@"id"]);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)turnRecycleOrderStatus:(NSString*)orderId into:(XYRecycleOrderStatus)status success:(void (^)())success errorString:(void (^)(NSString *))error{
    NSString* path = nil;
    switch (status){
        case XYRecycleOrderStatusSetOff:
            path = RECYCLE_SETOFF;
            break;
        default:
            break;
    }
    
    if (!path) {
        error(@"订单状态错误！");
        return -1;
    }
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
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


- (NSInteger)getRecycleOrderDetail:(NSString*)orderId success:(void (^)(XYRecycleOrderDetail* order))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RECYCLE_ORDER_DETAIL parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYRecycleOrderDetail* orderDetail = [XYRecycleOrderDetail mj_objectWithKeyValues:dto.data];
            success(orderDetail);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)getAllOrderList:(BOOL)isNew page:(NSInteger)page success:(void (^)(NSArray<XYAllTypeOrderDto*>* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(page) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:isNew ? NEW_ALL_ORDER_LIST:OLD_ALL_ORDER_LIST parameters:parameters isPost:false success:^(id response){
        XYPageListDtoContainer* listDto = [XYPageListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYAllTypeOrderDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getCompleteOrderList:(NSInteger)page success:(void (^)(NSMutableArray<XYAllTypeOrderDto*>* userOrderList, NSArray<XYAllTypeOrderDto*>* unpaidfeeList, NSArray<XYAllTypeOrderDto*>* paidfeeList, NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(page) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:OLD_ALL_ORDER_LIST parameters:parameters isPost:false success:^(id response){
        XYMultiplePageListDtoContainer* listDto = [XYMultiplePageListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSMutableArray* userOrderList = [XYAllTypeOrderDto mj_objectArrayWithKeyValuesArray:listDto.data[@"finish_order"]];
            NSArray* unpaidfeeList = [XYAllTypeOrderDto mj_objectArrayWithKeyValuesArray:listDto.data[@"platform_fee_pending"]];
            NSArray* paidfeeList = [XYAllTypeOrderDto mj_objectArrayWithKeyValuesArray:listDto.data[@"platform_fee_already"]];
            success(userOrderList,unpaidfeeList,paidfeeList,listDto.sum);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getAllClearOrderList:(NSString*)time page:(NSInteger)page success:(void (^)(NSArray<XYAllTypeOrderDto*>* orderList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:time forKey:@"time"];
    [parameters setValue:@(page) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:CLEAR_ALL_ORDER_LIST parameters:parameters isPost:false success:^(id response){
        XYPageListDtoContainer* listDto = [XYPageListDtoContainer mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYAllTypeOrderDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.sum);
        }else{
            error(listDto.msg);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getAllDaysWithClearOrders:(void (^)(NSArray<NSString*>* daysList))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:ALL_CLEAR_ORDER_DATE parameters:nil isPost:false success:^(id response){
        XYSingleArrayDto* listDto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (listDto.code == RESPONSE_SUCCESS || listDto.code == RESPONSE_NO_CONTENT){
            success(listDto.data);
        }else{
            error(listDto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)editRepairOrder:(NSString*)orderId
                         bid:(XYBrandType)bid
                      photo1:(NSString*)devnopic1
                      photo2:(NSString*)devnopic2
                      photo3:(NSString*)devnopic3
                      photo4:(NSString*)devnopic4
                     success:(void (^)())success
                 errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    [parameters setValue:devnopic1 forKey:@"devnopic1"];
    [parameters setValue:devnopic2 forKey:@"devnopic2"];
    [parameters setValue:devnopic3 forKey:@"devnopic3"];
    [parameters setValue:devnopic4 forKey:@"devnopic4"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_REPAIR_PHOTOS parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)getRecycleBonusList:(XYBonusListType)type page:(NSInteger)p success:(void (^)(NSArray* bonusList,NSInteger sum))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    NSString* typeStr = @"day";
    switch (type) {
        case XYBonusListTypeToday:
            typeStr = @"day";
            break;
        case XYBonusListTypeMonth:
            typeStr = @"month";
            break;
        case XYBonusListTypeTotal:
            typeStr = @"total";
            break;
        default:
            break;
    }
    [parameters setValue:typeStr forKey:@"type"];
    [parameters setValue:@(p) forKey:@"p"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:RECYCLE_BONUS parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:dto.data];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYRecycleBonusDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)getRepairSelections:(NSString*)orderId bid:(XYBrandType)bid success:(void (^)(XYRepairSelections* selections))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:REPAIR_SELECTIONS parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYRepairSelections* items = [XYRepairSelections mj_objectWithKeyValues:dto.data];
            success(items);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}


- (NSInteger)editWorkerSelfTaking:(NSString*)orderId
                              bid:(XYBrandType)bid
                            photo:(NSString*)img
                              lng:(NSString*)lng
                              lat:(NSString*)lat
                             addr:(NSString*)address
                          success:(void (^)())success
                      errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:@(bid) forKey:@"bid"];
    [parameters setValue:img forKey:@"img"];
    [parameters setValue:lng forKey:@"lng"];
    [parameters setValue:lat forKey:@"lat"];
    [parameters setValue:address forKey:@"address"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:EDIT_SELF_PHOTO parameters:parameters isPost:false success:^(id response){
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


@end
