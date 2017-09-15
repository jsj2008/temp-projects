//
//  XYRecycleUserInfoViewModel.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/7.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleUserInfoViewModel.h"
#import "XYStringUtil.h"

@implementation XYRecycleUserInfoViewModel

- (XYRecycleOrderDetail*)orderDetail{
    if (!_orderDetail) {
        _orderDetail = [[XYRecycleOrderDetail alloc]init];
        _orderDetail.rightUtilityButtons = nil;
    }
    return _orderDetail;
}

- (NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray = @[@[@""],@[@"客户姓名",@"联系电话",@"地址",@""],
                        @[@"设备号",@"身份证号",@"收款方式",@"",@"回收价格",@"备注"]];
    }
    return _titleArray;
}


- (XYRecycleUserCellType)getCellTypeByPath:(NSIndexPath*)path{
    NSInteger tag = (path.section*10+path.row);
    return (XYRecycleUserCellType)tag;
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

- (NSString*)getPlaceHolderByType:(XYRecycleUserCellType)type{
    switch (type) {
        case XYRecycleUserCellTypeName:
            return @"客户姓名（必填）";
        case XYRecycleUserCellTypePhone:
            return @"客户电话（必填）";
        case XYRecycleUserCellTypeSerialNumber:
            return @"设备号（必填）";
        case XYRecycleUserCellTypeIdentity:
            return @"(选填)";
        case XYRecycleUserCellTypeAddress:
            return @"详细地址（门牌号等必填）";
        case XYRecycleUserCellTypePayAccount:
            return @"客户微信/支付宝账号（公司支付必填）";
        case XYRecycleUserCellTypeRemark:
            return @"工程师备注（必填）";
        default:
            break;
    }
    return @"";
}

- (BOOL)getInputableByType:(XYRecycleUserCellType)type{
    switch (type) {
        case XYRecycleUserCellTypeName:
        case XYRecycleUserCellTypePhone:
        case XYRecycleUserCellTypeAddress:
        case XYRecycleUserCellTypeSerialNumber:
        case XYRecycleUserCellTypeIdentity:
        case XYRecycleUserCellTypePayAccount:
        case XYRecycleUserCellTypePayPrice:
        case XYRecycleUserCellTypeRemark:
        case XYRecycleUserCellTypePayType:
            return true;
            break;
        default:
            break;
    }
    return false;
}
- (BOOL)getSelectableByType:(XYRecycleUserCellType)type{
    switch (type) {
        case XYRecycleUserCellTypeCityArea:
            return true;
            break;
        default:
            break;
    }
    return false;

}
- (UIKeyboardType)getKeyboardByType:(XYRecycleUserCellType)type{
    switch (type) {
        case XYRecycleUserCellTypePhone:
        case XYRecycleUserCellTypePayPrice:
            return UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    return UIKeyboardTypeDefault;
}

- (void)setInputContent:(NSString*)content type:(XYRecycleUserCellType)type{
    switch (type) {
        case XYRecycleUserCellTypeName:
            self.orderDetail.user_name = content;
            break;
        case XYRecycleUserCellTypePhone:
            self.orderDetail.user_mobile = content;
            break;
        case XYRecycleUserCellTypeAddress:
            self.orderDetail.address = content;
            break;
        case XYRecycleUserCellTypeSerialNumber:
            self.orderDetail.device_sn = content;
            break;
        case XYRecycleUserCellTypeIdentity:
            self.orderDetail.id_card = content;
            break;
        case XYRecycleUserCellTypePayAccount:
            self.orderDetail.account_number = content;
            break;
        case XYRecycleUserCellTypePayPrice:
            self.orderDetail.price = [content integerValue];
            break;
        case XYRecycleUserCellTypeRemark:
            self.orderDetail.remark = content;
            break;
        default:
            break;
    }
}

- (NSString*)getInputContentByPath:(NSIndexPath*)path{
    XYRecycleUserCellType type = [self getCellTypeByPath:path];
    switch (type) {
        case XYRecycleUserCellTypeName:
            return self.orderDetail.user_name;
        case XYRecycleUserCellTypePhone:
            return self.orderDetail.user_mobile;
        case XYRecycleUserCellTypeAddress:
            return self.orderDetail.address;
        case XYRecycleUserCellTypeSerialNumber:
            return self.orderDetail.device_sn;
        case XYRecycleUserCellTypeIdentity:
            return self.orderDetail.id_card;
        case XYRecycleUserCellTypePayType:
            return self.orderDetail.payTypeStr;
        case XYRecycleUserCellTypePayAccount:
            return self.orderDetail.account_number;
        case XYRecycleUserCellTypePayPrice:
            return [NSString stringWithFormat:@"%@",@(self.orderDetail.price)];
        case XYRecycleUserCellTypeRemark:
            return self.orderDetail.remark;
        default:
            break;
    }
    return @"";
}

- (void)submitOrder{
   //必填
   if ([XYStringUtil isNullOrEmpty:self.orderDetail.mould_id] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.attrString] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.device_sn] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.remark] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.user_name] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.user_mobile] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.city] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.district] ||
       [XYStringUtil isNullOrEmpty:self.orderDetail.address]
       //||[XYStringUtil isNullOrEmpty:self.orderDetail.sign_url]
       ){
       if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:orderId:noteString:)]) {
           [self.delegate onOrderSubmitted:false orderId:nil noteString:@"请将信息填写完整！"];
       }
       return;
   }
    
    if([XYStringUtil isNullOrEmpty:self.orderDetail.account_number] &&
         ((self.orderDetail.payment_method == XYRecyclePayTypeCompanyWechat)
          || (self.orderDetail.payment_method == XYRecyclePayTypeCompanyAlipay))){
             if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:orderId:noteString:)]) {
                 [self.delegate onOrderSubmitted:false orderId:nil noteString:@"请填写支付方式！"];
             }
        return;
    }
    
    if(self.orderDetail.price <= 0){
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:orderId:noteString:)]) {
            [self.delegate onOrderSubmitted:false orderId:nil noteString:@"请填写正确的价格！"];
        }
        return;
    }
    
    [[XYAPIService shareInstance] createOrUpdateRecycleOrder:self.orderDetail.id device:self.orderDetail.mould_id selections:self.orderDetail.attrString price:self.orderDetail.price serialNumber:self.orderDetail.device_sn remark:self.orderDetail.remark name:self.orderDetail.user_name phone:self.orderDetail.user_mobile identity:self.orderDetail.id_card province:self.orderDetail.province city:self.orderDetail.city area:self.orderDetail.district address:self.orderDetail.address signPic:self.orderDetail.sign_url payType:self.orderDetail.payment_method account:self.orderDetail.account_number success:^(NSString *orderId) {
        [self.delegate onOrderSubmitted:true orderId:orderId noteString:nil];
    } errorString:^(NSString *error) {
        [self.delegate onOrderSubmitted:false orderId:nil noteString:error];
    }];
}

- (BOOL)isUserInfoAllFilled{
    
    if ([XYStringUtil isNullOrEmpty:self.orderDetail.device_sn] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.remark] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.user_name] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.user_mobile] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.city] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.district] ||
        [XYStringUtil isNullOrEmpty:self.orderDetail.address]){
        return false;
    }
    
    if([XYStringUtil isNullOrEmpty:self.orderDetail.account_number] &&
       ((self.orderDetail.payment_method == XYRecyclePayTypeCompanyWechat)
        || (self.orderDetail.payment_method == XYRecyclePayTypeCompanyAlipay))){
        return false;
    }
    
    if(self.orderDetail.price <= 0){
        return false;
    }

    return true;
}

@end
