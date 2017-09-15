//
//  XYAddPICCOrderViewModel.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCOrderViewModel.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVMediaFormat.h>
#import "XYStringUtil.h"

@implementation XYPICCOrderViewModel

- (NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray = @[@[@""],@[@"姓名",@"联系电话",@"地址",@"",@"预约时间"],
                        @[@"设备型号",@"保险商",@"保险业务",@"保险价格"],
                        @[@"设备IMEI",@"备注",@"邮箱",@"身份证号"],@[@""]];
    }
    return _titleArray;
}

- (XYPICCOrderDetail*)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[XYPICCOrderDetail alloc]init];
    }
    return _orderDetail;
}


- (XYPICCOrderCellType)getCellTypeByPath:(NSIndexPath*)path{
    NSInteger tag = (path.section*10+path.row);
    return (XYPICCOrderCellType)tag;
}

- (BOOL)getInputableByType:(XYPICCOrderCellType)type{
    //不可编辑
    if (![self getEditable]) {
        return false;
    }
    
    switch (type) {
        case XYPICCOrderCellTypeName:
        case XYPICCOrderCellTypePhone:
        case XYPICCOrderCellTypeAddress:
        case XYPICCOrderCellTypeIEMI:
        case XYPICCOrderCellTypeEmail:
        case XYPICCOrderCellTypeIdentity:
            return true;
            break;
        case XYPICCOrderCellTypeTime:
            return false; //丧尸的预约时间
            break;
        default:
            break;
    }
    return false;
}

- (BOOL)getSelectableByType:(XYPICCOrderCellType)type{
    switch (type) {
        case XYPICCOrderCellTypeDevice:
        case XYPICCOrderCellTypeCompany:
        case XYPICCOrderCellTypePlan:
        case XYPICCOrderCellTypeRemark:
            return true;
            break;
        default:
            break;
    }
    return false;
}

- (UIKeyboardType)getKeyboardByType:(XYPICCOrderCellType)type{
    switch (type) {
        case XYPICCOrderCellTypeName:
        case XYPICCOrderCellTypeAddress:
        case XYPICCOrderCellTypeIEMI:
        case XYPICCOrderCellTypeRemark:
        case XYPICCOrderCellTypeEmail:
        case XYPICCOrderCellTypeIdentity:
            return UIKeyboardTypeDefault;
        case XYPICCOrderCellTypePhone:
            return UIKeyboardTypeNumberPad;
        case XYPICCOrderCellTypeTime:
            return UIKeyboardTypeDefault;//????
        default:
            break;
    }
    return UIKeyboardTypeDefault;
}

- (NSString*)getPlaceHolderByType:(XYPICCOrderCellType)type{
    switch (type) {
        case XYPICCOrderCellTypeName:
            return @"客户姓名（必填）";
        case XYPICCOrderCellTypePhone:
            return @"客户电话（必填）";
        case XYPICCOrderCellTypeIEMI:
            return @"设备IMEI（必填）";
        case XYPICCOrderCellTypeEmail:
        case XYPICCOrderCellTypeIdentity:
            return @"(选填)";
        case XYPICCOrderCellTypeAddress:
            return @"详细地址（门牌号等必填）";
        case XYPICCOrderCellTypeRemark:
            return @"工程师备注（必填）";
        default:
            break;
    }
    return @"";
}

- (NSString*)getTitleByPath:(NSIndexPath*)path{
    NSString* title = @"";
    @try {
        title = [[self.titleArray objectAtIndex:path.section]objectAtIndex:path.row];
    }
    @catch (NSException *exception) {
        TTDEBUGLOG(@"exception:%@",exception);
        title = @"";
    }
    @finally {
        return title;
    }
}

- (void)setInputContent:(NSString*)content type:(XYPICCOrderCellType)type{
    switch (type) {
        case XYPICCOrderCellTypeName:
            self.orderDetail.user_name = content;
            break;
        case XYPICCOrderCellTypePhone:
            self.orderDetail.user_mobile = content;
            break;
        case XYPICCOrderCellTypeAddress:
            self.orderDetail.address = content;
            break;
        case XYPICCOrderCellTypeTime:
            //self.orderDetail.user_name = content; ??
            break;
        case XYPICCOrderCellTypeIEMI:
            self.orderDetail.imei = content;
            break;
        case XYPICCOrderCellTypeRemark:
            self.orderDetail.engineer_remark = content;
            break;
        case XYPICCOrderCellTypeEmail:
            self.orderDetail.user_email = content;
            break;
        case XYPICCOrderCellTypeIdentity:
            self.orderDetail.id_number = content;
            break;
        default:
            break;
    }
}

- (NSString*)getInputContentByPath:(NSIndexPath*)path{
    XYPICCOrderCellType type = [self getCellTypeByPath:path];
    switch (type) {
        case XYPICCOrderCellTypeName:
            return self.orderDetail.user_name;
            break;
        case XYPICCOrderCellTypePhone:
            return self.orderDetail.user_mobile;
            break;
        case XYPICCOrderCellTypeAddress:
            return self.orderDetail.address;
            break;
        case XYPICCOrderCellTypeTime:
            return @"预约时间暂未开放";
            break;
        case XYPICCOrderCellTypeIEMI:
            return self.orderDetail.imei;
            break;
        case XYPICCOrderCellTypeRemark:
            return self.orderDetail.engineer_remark;
            break;
        case XYPICCOrderCellTypeEmail:
            return self.orderDetail.user_email;
            break;
        case XYPICCOrderCellTypeIdentity:
            return self.orderDetail.id_number;
            break;
        case XYPICCOrderCellTypeDevice:
        {
            if (self.orderDetail.mould_id == nil || [self.orderDetail.mould_id integerValue]<=0) {
                return [NSString stringWithFormat:@"%@/%@/%@/%@",(XY_NOTNULL(self.orderDetail.product_name, @"产品")),XY_NOTNULL(self.orderDetail.brand_name,@"品牌"),XY_NOTNULL(self.orderDetail.mould_name,@"设备"),@(self.orderDetail.equip_price)];
                //有自定义机型
            }else{
                return self.orderDetail.mould_name;//有已选机型
            }
        }
        case XYPICCOrderCellTypeCompany:
            return self.orderDetail.company_name;
        case XYPICCOrderCellTypePlan:
            return self.orderDetail.insurance_name;
        case XYPICCOrderCellTypeTotalPay:
            return [NSString stringWithFormat:@"%@",@(self.orderDetail.price)];
//        case XYPICCOrderCellTypeBonus:
//            return [NSString stringWithFormat:@"%@",@(self.orderDetail.push_money)];
        default:
            break;
    }
    return @"";
}

- (void)setUrl:(NSString*)url forName:(NSString*)name{
    if ([name isEqualToString:@"equip_pic1"]) {
        self.orderDetail.equip_pic1 = url;
    }else if ([name isEqualToString:@"equip_pic2"]) {
        self.orderDetail.equip_pic2 = url;
    }else if ([name isEqualToString:@"idcard_pic1"]) {
        self.orderDetail.idcard_pic1 = url;
    }else if ([name isEqualToString:@"idcard_pic2"]) {
        self.orderDetail.idcard_pic2 = url;
    }
    return;
}


- (void)getPICCOrderByOddNumber:(NSString*)odd_number{
    [[XYAPIService shareInstance] getPICCOrderDetail:odd_number success:^(XYPICCOrderDetail *order) {
        self.orderDetail = order;
        if ([self.delegate respondsToSelector:@selector(onOrderLoaded:noteString:)]) {
            [self.delegate onOrderLoaded:true noteString:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onOrderLoaded:noteString:)]) {
            [self.delegate onOrderLoaded:false noteString:error];
        }
    }];
}

- (void)cancelPICCOrderById:(NSString*)orderId{
    
}

- (void)submitPICCOrder{
    
    //各种必填字段
    if ([XYStringUtil isNullOrEmpty:self.orderDetail.user_name] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.user_mobile] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.city] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.district] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.address]||
        [XYStringUtil isNullOrEmpty:self.orderDetail.imei]||
        [XYStringUtil isNullOrEmpty:self.orderDetail.insurer_id] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.coverage_id] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.equip_pic1]||
        [XYStringUtil isNullOrEmpty:self.orderDetail.equip_pic2] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.engineer_remark]) {
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:false noteString:@"请填写完整信息！"];
        }
        return;
    }
    
    if(self.orderDetail.price <= 0 ||[XYStringUtil isNullOrEmpty:self.orderDetail.rate_id]){
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:false noteString:@"没有合法的保险报价，请重新获取！"];
        }
        return;
    }
    
    //设备id和自定义机型二选一
    if ([XYStringUtil isNullOrEmpty:self.orderDetail.mould_id]) {
        if([XYStringUtil isNullOrEmpty:self.orderDetail.product_name]||
           [XYStringUtil isNullOrEmpty:self.orderDetail.brand_name]||
           [XYStringUtil isNullOrEmpty:self.orderDetail.mould_name]||
           self.orderDetail.equip_price <=0)
        {
            if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
               [self.delegate onOrderSubmitted:false noteString:@"请选择/填写完整的设备信息！"];
            }
            return;
        }
    }
    
//    //过滤非法姓名之客户端向
//    NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY];
//    NSString* filteredName = [XYStringUtil trimSpacesOfString:self.orderDetail.user_name];
//    if ([filteredName rangeOfCharacterFromSet:cs].location!= NSNotFound) {
//        [self.delegate onOrderSubmitted:false noteString:@"姓名不得包含数字！"];
//        return;
//    }
//    NSArray* na = @[@"先生",@"女士",@"小姐"];
//    for (NSString* word in na) {
//        if ([filteredName rangeOfString:word].location!= NSNotFound) {
//            [self.delegate onOrderSubmitted:false noteString:@"请输入正确的姓名！"];
//            return;
//        }
//    }
    
    [[XYAPIService shareInstance] piccCreateOrUpdateOrder:self.orderDetail.insurance_oid name:self.orderDetail.user_name phone:self.orderDetail.user_mobile cityId:self.orderDetail.city districtId:self.orderDetail.district addr:self.orderDetail.address rate:self.orderDetail.rate_id imei:self.orderDetail.imei mould:self.orderDetail.mould_id plan:self.orderDetail.coverage_id price:[NSString stringWithFormat:@"%@",@(self.orderDetail.price)] company:self.orderDetail.insurer_id equip_pic1:self.orderDetail.equip_pic1 equip_pic2:self.orderDetail.equip_pic2 idcard_pic1:self.orderDetail.idcard_pic1 idcard_pic2:self.orderDetail.idcard_pic2 id_number:self.orderDetail.id_number email:self.orderDetail.user_email product:self.orderDetail.product_name brand:self.orderDetail.brand_name mould:self.orderDetail.mould_name mouldPrice:[NSString stringWithFormat:@"%@",@(self.orderDetail.equip_price)] remark:self.orderDetail.engineer_remark success:^{
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:true noteString:nil];
        }
     } errorString:^(NSString *err) {
         if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
             [self.delegate onOrderSubmitted:false noteString:err];
         }
     }];
}

- (BOOL)getEditable{//待定
    if(self.orderDetail.status == XYPICCOrderStatusCreated || self.orderDetail.status == XYPICCOrderStatusAccepted){
        return true;
    }
    return false;
}

- (BOOL)getUploadable{
    return true;
}

- (BOOL)getPhotoTakingAvailable{

    AVAuthorizationStatus photoAuthor = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (photoAuthor == AVAuthorizationStatusRestricted || photoAuthor ==AVAuthorizationStatusDenied){
        return false;
    }
    
    return true;
}

- (BOOL)getPhotoSavingAvailable{
    ALAuthorizationStatus albumAuthor = [ALAssetsLibrary authorizationStatus];
    if (albumAuthor == ALAuthorizationStatusRestricted || albumAuthor == ALAuthorizationStatusDenied){
        return false;
    }
    return true;
}


@end
