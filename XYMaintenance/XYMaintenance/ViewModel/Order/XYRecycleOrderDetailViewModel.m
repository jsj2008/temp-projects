//
//  XYRecycleOrderDetailViewModel.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleOrderDetailViewModel.h"

@implementation XYRecycleOrderDetailViewModel

- (NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray = @[@[@""],@[@"设备类型:",@"用户姓名:",@"联系电话:",@"用户地址:",@"预约时间:",@"用户备注:"],
                        @[@"支付方式:",@"支付账户:",@"回收价格:",@"设备序列号:"]];
    }
    return _titleArray;
}

- (XYRecycleOrderDetailCellType)getCellTypeByPath:(NSIndexPath*)path{
    NSInteger tag = (path.section*10+path.row);
    return (XYRecycleOrderDetailCellType)tag;
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

- (NSString*)getContentByPath:(NSIndexPath*)path{
    XYRecycleOrderDetailCellType type = [self getCellTypeByPath:path];
    switch (type) {
        case XYRecycleOrderDetailCellTypeDevice:
            return self.orderDetail.mould_name;
            break;
        case XYRecycleOrderDetailCellTypeUserName:
            return self.orderDetail.user_name;
            break;
        case XYRecycleOrderDetailCellTypePhone:
            return self.orderDetail.user_mobile;
            break;
        case XYRecycleOrderDetailCellTypeFullAddress:
            return self.orderDetail.address;
            break;
        case XYRecycleOrderDetailCellTypeReserveTime:
            return self.orderDetail.reserve_time;
            break;
        case XYRecycleOrderDetailCellTypeUserRemark:
            return self.orderDetail.remark;
            break;
        case XYRecycleOrderDetailCellTypePayType:
            return self.orderDetail.payTypeStr;
            break;
        case XYRecycleOrderDetailCellTypePayAccount:
            return self.orderDetail.account_number;
            break;
        case XYRecycleOrderDetailCellTypeFinalPriceAndPay:
            return self.orderDetail.priceAndPay;
            break;
        case XYRecycleOrderDetailCellTypeSerialNumber:
            return self.orderDetail.device_sn;
        default:
            break;
    }
    return @"";
}

- (BOOL)shouldHightLight:(NSIndexPath*)path{
    XYRecycleOrderDetailCellType type = [self getCellTypeByPath:path];
    switch (type) {
        case XYRecycleOrderDetailCellTypePhone:
        case XYRecycleOrderDetailCellTypeFullAddress:
            return true;
        default:
            break;
    }
    return false;
}


- (BOOL)getSelectableByType:(XYRecycleOrderDetailCellType)type{
    if (type == XYRecycleOrderDetailCellTypeDevice) {
        if ([self isBeforeOrderDone]) {
           return true;
        }
    }
    return false;
}


#pragma mark - logic

- (void)loadOrderDetail:(NSString*)orderId{
   [[XYAPIService shareInstance]getRecycleOrderDetail:orderId success:^(XYRecycleOrderDetail *order) {
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

- (void)setOff{
    [[XYAPIService shareInstance]turnRecycleOrderStatus:self.orderDetail.id into:XYRecycleOrderStatusSetOff success:^{
        if ([self.delegate respondsToSelector:@selector(onSetOff:noteString:)]) {
            [self.delegate onSetOff:true noteString:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onSetOff:noteString:)]) {
            [self.delegate onSetOff:false noteString:error];
        }
    }];
}

- (BOOL)isBeforeOrderDone{
    XYRecycleOrderStatus status = self.orderDetail.status;
    return (status == XYRecycleOrderStatusCreated) || (status == XYRecycleOrderStatusAssigned) || (status == XYRecycleOrderStatusSetOff);
}

@end
