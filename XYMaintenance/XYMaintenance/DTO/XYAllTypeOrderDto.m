//
//  XYAllTypeOrderDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/15.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAllTypeOrderDto.h"
#import "XYStringUtil.h"
#import "MJExtension.h"
#import "XYDtoTransferer.h"

@implementation XYAllTypeOrderDto

- (NSString*)statusString{
    switch (self.type) {
        case XYAllOrderTypeRepair:
            return [XYOrderBase getStatusString:self.status];
        case XYAllOrderTypeInsurance:
            return [XYPICCOrderDto getStatusString:self.status];
        case XYAllOrderTypeRecycle:
            return [XYRecycleOrderDetail getStatusStringByStatus:self.status];
        default:
            break;
    }
    return @"";
}


- (NSString*)repairTimeString{
    if ([XYStringUtil isNullOrEmpty:_repairTimeString]) {
        _repairTimeString = [XYDtoTransferer xy_reservetimeTransform:self.reserveTime reserveTime2:self.reserveTime2];
    }
    return _repairTimeString;
}

- (NSString*)finishTimeString{
    if ([XYStringUtil isNullOrEmpty:_finishTimeString]) {
        _finishTimeString =  [[NSDate dateWithTimeIntervalSince1970:[self.FinishTime doubleValue]] formattedDateWithFormat:@"yyyy/MM/dd HH:mm"];
    }
    return _finishTimeString;
}

- (NSAttributedString*)priceAndPay{
    if (!_priceAndPay) {
        if(!self.payStatus){
            _priceAndPay = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"￥%@元（未支付）",@(self.TotalAccount)] lightRange:@"（未支付）" lightColor:THEME_COLOR];
        }else{
            _priceAndPay = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"￥%@元",@(self.TotalAccount)] lightRange:@"" lightColor:GREEN_COLOR];
        }
    }
    return _priceAndPay;
}

//- (NSString*)payIconName{
//    if (!_payIconName) {
//        _payIconName = [XYOrderBase getPaymentIconName:self.payment];
//    }
//    return _payIconName;
//}

- (NSMutableArray*)rightUtilityButtons{
    if (!_rightUtilityButtons) {
        if (self.type == XYAllOrderTypeRepair) {
            //只有维修订单有左滑动技能
            _rightUtilityButtons = [XYOrderBase getRightUtilityButtonsByStatus:self.status payStatus:self.payStatus bid:self.bid];
        }
    }
    return _rightUtilityButtons;
}

//- (NSString*)paymentDes{
//    switch (self.type) {
//        case XYAllOrderTypeRepair:
//            return [XYOrderBase getPaymentDes:self.payment];
//        case XYAllOrderTypeInsurance:
//        case XYAllOrderTypeRecycle:
//            return @"已支付";
//        default:
//            break;
//    }
//    return @"";
//}

+ (XYAllTypeOrderDto*)convertRepairOrder:(XYOrderBase*)orderBase from:(XYAllTypeOrderDto*)originOrder{
    
    if (!originOrder) {
        return nil;
    }
    
    originOrder.uName = orderBase.uName;
    originOrder.uMobile = orderBase.uMobile;
    originOrder.color = orderBase.color;
    originOrder.reserveTime = orderBase.reserveTime;
    originOrder.reserveTime2 = orderBase.reserveTime2;
    originOrder.repairTimeString = orderBase.repairTimeString;
    originOrder.status = orderBase.status;
    originOrder.statusString = orderBase.statusString;
    originOrder.FaultTypeDetail = orderBase.FaultTypeDetail;
    originOrder.FinishTime = orderBase.FinishTime;
    originOrder.finishTimeString = orderBase.finishTimeString;
    originOrder.payStatus = orderBase.payStatus;
    originOrder.priceAndPay = orderBase.priceAndPay;
    originOrder.TotalAccount = orderBase.TotalAccount;
    originOrder.rightUtilityButtons = orderBase.rightUtilityButtons;
    return originOrder;
}

@end
