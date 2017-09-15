//
//  XYRecycleDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRecycleDto.h"
#import "XYConfig.h"
#import "NSMutableArray+SWUtilityButtons.h"


@implementation XYRecycleDeviceDto

@end

@implementation XYRecycleSelectionItem

@end

@implementation XYRecycleSelectionsDto

@end

@implementation XYRecycleOrderDetail

// 0:公司支付微信 1:公司支付支付宝 2:工程师垫付现金 3:工程师垫付微信 4:工程师垫付支付宝
- (NSArray*)payTypeArray{
    if (!_payTypeArray) {
        _payTypeArray = @[@"公司支付-微信",@"公司支付-支付宝",@"工程师垫付-现金",@"工程师垫付-微信",@"工程师垫付-支付宝"];
    }
    return _payTypeArray;
}

- (NSString*)payTypeStr{
    if (self.payment_method >=0 && self.payment_method<self.payTypeArray.count) {
        return [self.payTypeArray objectAtIndex:self.payment_method];
    }
    return @"未知";
}

- (NSString*)priceAndPay{
    return [NSString stringWithFormat:@"%@元（%@）",@(self.price),self.payment_status?@"已支付":@"未支付"];
}

//XYRecycleOrderStatusCreated = 0,
//XYRecycleOrderStatusAssigned = 1,
//XYRecycleOrderStatusSetOff = 2,
//XYRecycleOrderStatusDone = 3,
//XYRecycleOrderStatusSold = 4,
//XYRecycleOrderStatusCancelled = 5,

- (NSString*)buttonTitleStr{
    switch (self.status) {
        case XYRecycleOrderStatusCreated:
        case XYRecycleOrderStatusAssigned:
            return @"出发";
            break;
        case XYRecycleOrderStatusSetOff:
            return @"确认信息";
            break;
        default:
            break;
    }
    return nil;
}

- (NSMutableArray*)rightUtilityButtons{
    if (!_rightUtilityButtons) {
        _rightUtilityButtons = [[NSMutableArray alloc]init];
        switch (self.status) {
            case XYRecycleOrderStatusCreated:
            case XYRecycleOrderStatusAssigned:
                [_rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0x1a80ff) title:@"出发"];
                break;
            case XYRecycleOrderStatusSetOff:
                [_rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0x1a80ff) title:@"确认信息"];
                break;
            default:
                break;
        }
    }
    return _rightUtilityButtons;
}


+ (NSString*)getStatusStringByStatus:(XYRecycleOrderStatus)status{
    switch (status) {
        case XYRecycleOrderStatusCreated:
            return @"已创建";
            break;
        case XYRecycleOrderStatusAssigned:
            return @"已预约";
            break;
        case XYRecycleOrderStatusSetOff:
            return @"已出发";
            break;
        case XYRecycleOrderStatusDone:
            return @"已完成";
            break;
        case XYRecycleOrderStatusSold:
            return @"已出售";
            break;
        case XYRecycleOrderStatusCancelled:
            return @"已取消";
            break;
        default:
            break;
    }
    return @"";
}

- (NSString*)statusStr{
    return [XYRecycleOrderDetail getStatusStringByStatus:self.status];
}

@end
