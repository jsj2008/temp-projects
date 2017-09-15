//
//  XYAPIService+V4API.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V4API)//PICC保险订单相关


- (NSInteger)getPICCOrderDetail:(NSString*)odd_number success:(void (^)(XYPICCOrderDetail *))success errorString:(void (^)(NSString *))error;

- (NSInteger)getPICCCompanyList:(void (^)(NSArray* companies))success errorString:(void (^)(NSString *))error;

- (NSInteger)getPICCPlanList:(NSString*)insurer_id success:(void (^)(NSArray* companies))success errorString:(void (^)(NSString *))error;

//（必须参数：insurer_id 保险公司id和coverage_id险种id  二选一参数：mould_id 型号id 或者 mould_price 设备价格）
- (NSInteger)getPICCPriceByCompany:(NSString*)insurer_id plan:(NSString*)coverage_id device:(NSString*)mould_id price:(NSString*)mould_price product:(NSString*)product_name brand:(NSString*)brand_name device:(NSString*)mould_name success:(void (^)(XYPICCPrice* priceInfo))success errorString:(void (^)(NSString *))error;

// http://api.hiweixiu.com/activities/opt-insurance-order?user_name=testorder&user_mobile=15000246204&city=310100&district=310110&address=test&rate_id=1
//&imei=123123123&client_type=9&mould_id=29&coverage_id=1&price=30&insurer_id=2&equip_pic1=test1.jpg
//&equip_pic2=test2.jpg  其他参数可选 rate_id=getPICCPriceByCompany得到的id
//如果上面加上id参数则为编辑该订单
- (NSInteger)piccCreateOrUpdateOrder:(NSString*)id name:(NSString*)user_name phone:(NSString*)user_mobile cityId:(NSString*)city districtId:(NSString*)district addr:(NSString*)address rate:(NSString*)rate_id imei:(NSString*)imei mould:(NSString*)mould_id plan:(NSString*)coverage_id price:(NSString*)price company:(NSString*)insurer_id equip_pic1:(NSString*)equip_pic1 equip_pic2:(NSString*)equip_pic2 idcard_pic1:(NSString*)idcard_pic1 idcard_pic2:(NSString*)idcard_pic2 id_number:(NSString*)id_number email:(NSString*)user_email product:(NSString*)product_name brand:(NSString*)brand_name mould:(NSString*)mould_name mouldPrice:(NSString*)equip_price remark:(NSString*)engineer_remark success:(void (^)())success errorString:(void (^)(NSString *))error;

/*
 *  上传图片通用接口
 */
- (NSInteger)uploadImage:(NSData*)imgData type:(XYPictureType)type parameters:(NSDictionary*)params success:(void (^)(NSString *))success errorString:(void (^)(NSString *))error;


//(废弃)->API6
//- (NSInteger)getPICCOrderList:(NSInteger)status success:(void (^)(NSDictionary* dic))success errorString:(void (^)(NSString *))error;
//- (NSInteger)getPICCClearedOrdersByDate:(NSString*)time success:(void (^)(NSArray *))success errorString:(void (^)(NSString *))error;

@end
