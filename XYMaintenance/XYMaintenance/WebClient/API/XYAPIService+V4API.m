//
//  XYAPIService+V4API.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService+V4API.h"
#import "XYStringUtil.h"

static NSString* const PICC_ORDER_LIST = @"activities/get-insurance-orders";//picc订单列表 suck
static NSString* const PICC_ORDER_DETAIL = @"activities/get-insurance-order-info";//picc订单详情
static NSString* const PICC_COMPANY_LIST = @"activities/get-insurace-company-list";//
static NSString* const PICC_PLAN_LIST = @"activities/get-insurance-coverages";//
static NSString* const PICC_GET_PRICE = @"activities/get-insurance-rate";//
static NSString* const PICC_UPDATE_ORDER = @"activities/opt-insurance-order";//
static NSString* const PICC_CLEARED_ORDERS = @"activities/get-payed-order-list";//
static NSString* const UPLOAD_PICTURE = @"activities/upload-images";//

@implementation XYAPIService (V4API)


//{"code":200,"data":{"192991":[{"id":"15","odd_number":"TPYg16060314050529","order_id":"192991","client_type":"2","user_name":"马英卫","user_mobile":"15601622966","user_email":"","id_number":null,"lng":"121.506751","lat":"31.097546","province":"310000","city":"310100","district":"310112","address":"陈行路2388号3号楼3楼","product_id":"15","product_name":"手机","brand_id":"24","brand_name":"苹果","mould_id":"29","mould_name":"iPhone5S","insurer_id":"4","coverage_id":"3","rate_id":"2","equip_price":"0","imei":"12345","price":"200","expire_dt":null,"status":"10","pay_status":"1","cancel_status":"0","refund_status":"1","repair_person":"118","push_money":"10","equip_pic1":"http://pic.hiweixiu.com/images/uploadImg/insurance/201606/8111d79eb02d4159eb1c9b01d25dd5533703.jpg","equip_pic2":"http://pic.hiweixiu.com/images/uploadImg/insurance/201606/8111d79eb02d4159eb1c9b01d25dd5532409.jpg","idcard_pic1":"http://pic.hiweixiu.com/images/uploadImg/insurance/201606/8111d79eb02d4159eb1c9b01d25dd5536857.jpg","idcard_pic2":"http://pic.hiweixiu.com/images/uploadImg/insurance/201606/8111d79eb02d4159eb1c9b01d25dd5539223.jpg","create_dt":"2016-06-03 14:05:05","create_with":"0","create_by":"0","accepted_dt":"2016-06-03 15:44:11","accepted_with":"1","accepted_by":"40","confirm_upload_dt":null,"confirm_upload_with":"0","confirm_upload_by":"0","pay_dt":null,"pay_with":"0","pay_by":"0","confirm_pay_dt":"2016-06-03 15:48:49","confirm_pay_with":"1","confirm_pay_by":"40","valid_dt":null,"valid_with":"0","valid_by":"0","use_dt":null,"use_with":"0","use_by":"0","confirm_use_dt":null,"confirm_use_with":"0","confirm_use_by":"0","cancel_dt":"2016-06-03 15:57:24","cancel_with":"1","cancel_by":"40","cancel_reason":"任性","refund_dt":"2016-06-03 15:56:46","refund_with":"1","refund_by":"40","refund_from_with":"0","refund_from_by":"0","refund_price":"100","refund_reason":"任性","is_del":"0","update_dt":"2016-06-03 15:57:24","update_with":"1","update_by":"40"}]},"mes":"success"}

- (NSInteger)getPICCOrderList:(NSInteger)status success:(void (^)(NSDictionary* dic))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:@(status) forKey:@"status"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_ORDER_LIST parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            for (NSString* key in dto.data) {
                NSArray* array = [XYPICCOrderDto mj_objectArrayWithKeyValuesArray:dto.data[key]];
                [dic setValue:array forKey:key];
            }
            success(dic);
        }else if(dto.code == RESPONSE_NO_CONTENT){
            NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
            success(dic);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

//{"code":200,"data":{"id":"18","odd_number":"TPYC16060309494738","order_id":null,"client_type":"9","user_name":"yaoshuang222","user_mobile":"15000246204","user_email":null,"id_number":null,"lng":"121.526077","lat":"31.259541","province":"310000","city":"310100","district":"310110","address":"test","product_id":"15","product_name":"手机","brand_id":"24","brand_name":"苹果","mould_id":"29","mould_name":"iPhone5S","insurer_id":"2","coverage_id":"1","rate_id":"1","equip_price":"0","imei":"123123123","price":"30","expire_dt":null,"status":"0","pay_status":"0","cancel_status":"0","refund_status":"0","repair_person":"0","push_money":"0","equip_pic1":"test1.jpg","equip_pic2":"test2.jpg","idcard_pic1":null,"idcard_pic2":null,"create_dt":"2016-06-03 09:49:47","create_with":"2","create_by":"118","accepted_dt":null,"accepted_with":"0","accepted_by":"0","confirm_upload_dt":null,"confirm_upload_with":"0","confirm_upload_by":"0","pay_dt":null,"pay_with":"0","pay_by":"0","confirm_pay_dt":null,"confirm_pay_with":"0","confirm_pay_by":"0","valid_dt":null,"valid_with":"0","valid_by":"0","use_dt":null,"use_with":"0","use_by":"0","confirm_use_dt":null,"confirm_use_with":"0","confirm_use_by":"0","cancel_dt":null,"cancel_with":"0","cancel_by":"0","cancel_reason":"0","refund_dt":null,"refund_with":"0","refund_by":"0","refund_from_with":"0","refund_from_by":"0","refund_price":"0","refund_reason":"0","is_del":"0","update_dt":"2016-06-03 09:49:47","update_with":"2","update_by":"118"},"mes":"success"}

- (NSInteger)getPICCOrderDetail:(NSString*)odd_number success:(void (^)(XYPICCOrderDetail *))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:odd_number forKey:@"odd_number"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_ORDER_DETAIL parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYPICCOrderDetail* detail = [XYPICCOrderDetail mj_objectWithKeyValues:dto.data];
            success(detail);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPICCCompanyList:(void (^)(NSArray* companies))success errorString:(void (^)(NSString *))error{
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_COMPANY_LIST parameters:nil isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYPICCCompany mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)getPICCPlanList:(NSString*)insurer_id success:(void (^)(NSArray* companies))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:insurer_id forKey:@"insurer_id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_PLAN_LIST parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYPICCPlan mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

//（必须参数：insurer_id 保险公司id和coverage_id险种id  二选一参数：mould_id 型号id 或者 mould_price 设备价格）
- (NSInteger)getPICCPriceByCompany:(NSString*)insurer_id plan:(NSString*)coverage_id device:(NSString*)mould_id price:(NSString*)mould_price product:(NSString*)product_name brand:(NSString*)brand_name device:(NSString*)mould_name success:(void (^)(XYPICCPrice* priceInfo))success errorString:(void (^)(NSString *))error{

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:insurer_id forKey:@"insurer_id"];
    [parameters setValue:coverage_id forKey:@"coverage_id"];
    [parameters setValue:mould_id forKey:@"mould_id"];
    
    [parameters setValue:mould_price forKey:@"mould_price"];
    [parameters setValue:product_name forKey:@"product_name"];
    [parameters setValue:brand_name forKey:@"brand_name"];
    [parameters setValue:mould_name forKey:@"mould_name"];

    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_GET_PRICE parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYPICCPrice* priceInfo = [XYPICCPrice mj_objectWithKeyValues:dto.data];
            success(priceInfo);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

// http://api.hiweixiu.com/activities/opt-insurance-order?user_name=testorder&user_mobile=15000246204&city=310100&district=310110&address=test&rate_id=1
//&imei=123123123&client_type=9&mould_id=29&coverage_id=1&price=30&insurer_id=2&equip_pic1=test1.jpg
//&equip_pic2=test2.jpg  其他参数可选 rate_id=getPICCPriceByCompany得到的id
//如果上面加上id参数则为编辑该订单
- (NSInteger)piccCreateOrUpdateOrder:(NSString*)orderId name:(NSString*)user_name phone:(NSString*)user_mobile cityId:(NSString*)city districtId:(NSString*)district addr:(NSString*)address rate:(NSString*)rate_id imei:(NSString*)imei mould:(NSString*)mould_id plan:(NSString*)coverage_id price:(NSString*)price company:(NSString*)insurer_id equip_pic1:(NSString*)equip_pic1 equip_pic2:(NSString*)equip_pic2 idcard_pic1:(NSString*)idcard_pic1 idcard_pic2:(NSString*)idcard_pic2 id_number:(NSString*)id_number email:(NSString*)user_email product:(NSString*)product_name brand:(NSString*)brand_name mould:(NSString*)mould_name mouldPrice:(NSString*)equip_price remark:(NSString*)engineer_remark success:(void (^)())success errorString:(void (^)(NSString *))error{
   
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:orderId forKey:@"id"];
    [parameters setValue:user_name forKey:@"user_name"];
    [parameters setValue:user_mobile forKey:@"user_mobile"];
    [parameters setValue:city forKey:@"city"];
    [parameters setValue:district forKey:@"district"];
    [parameters setValue:address forKey:@"address"];
    [parameters setValue:rate_id forKey:@"rate_id"];
    [parameters setValue:imei forKey:@"imei"];
    [parameters setValue:mould_id forKey:@"mould_id"];
    [parameters setValue:coverage_id forKey:@"coverage_id"];
    [parameters setValue:price forKey:@"price"];
    [parameters setValue:insurer_id forKey:@"insurer_id"];
    [parameters setValue:equip_pic1 forKey:@"equip_pic1"];
    [parameters setValue:equip_pic2 forKey:@"equip_pic2"];
    [parameters setValue:idcard_pic1 forKey:@"idcard_pic1"];
    [parameters setValue:idcard_pic2 forKey:@"idcard_pic2"];
    [parameters setValue:id_number forKey:@"id_number"];
    [parameters setValue:user_email forKey:@"user_email"];
    [parameters setValue:product_name forKey:@"product_name"];
    [parameters setValue:brand_name forKey:@"brand_name"];
    [parameters setValue:mould_name forKey:@"mould_name"];
    [parameters setValue:equip_price forKey:@"equip_price"];
    [parameters setValue:engineer_remark forKey:@"engineer_remark"];
    
    if(orderId == nil){//是添加订单，则传client_type
       [parameters setValue:@(9) forKey:@"client_type"]; //suck
    }
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_UPDATE_ORDER parameters:parameters isPost:false success:^(id response){
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

- (NSInteger)getPICCClearedOrdersByDate:(NSString*)time success:(void (^)(NSArray *))success errorString:(void (^)(NSString *))error{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:time forKey:@"time"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PICC_CLEARED_ORDERS parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* array = [XYPICCOrderDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(array);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
    
}

- (NSInteger)uploadImage:(NSData*)imgData type:(XYPictureType)type parameters:(NSDictionary*)params success:(void (^)(NSString *))success errorString:(void (^)(NSString *))error{

    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:params];
    [parameters setValue:@(type) forKey:@"type"];
    
    //约定 嗯 there is no time for elegance
    //name:@"insurance" fileName:@"insurance.jpg"....
    
    NSInteger requestId = [[XYHttpClient sharedInstance]uploadFile:imgData params:parameters name:@"insurance" fileName:@"insurance.jpg" type:@"image/jpg" path:UPLOAD_PICTURE success:^(id responseJson) {
        XYStringDto* dto = [XYStringDto mj_objectWithKeyValues:responseJson];
        if (dto.code == RESPONSE_SUCCESS){
            success([XYStringUtil urlTohttps:dto.data]);
        }else{
            error(dto.mes);
        }
    } failure:^(NSString *errorString) {
         error?error(errorString):nil;
    }];
  
    return requestId;
}



@end
