//
//  XYPICCOrderDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCOrderDto.h"
#import "XYStringUtil.h"
#import "GTMNSString+HTML.h"


@implementation XYPICCCompany

@end

@implementation XYPICCPlan

@end

@implementation XYPICCPrice

@end

@implementation XYPICCOrderDto

+ (NSString*)getStatusString:(XYPICCOrderStatus)status{
    switch (status) {
        case XYPICCOrderStatusCreated:
            return @"已提交";
        case XYPICCOrderStatusAccepted:
            return @"已受理";
        case XYPICCOrderStatusPaid:
            return @"已支付";
        case XYPICCOrderStatusValid:
            return @"已生效";
        case XYPICCOrderStatusUsed:
            return @"已使用";
        default:
            break;
    }
    return @"";
}

- (NSString*)statusStr{
    return [XYPICCOrderDto getStatusString:self.status];
}

- (NSAttributedString*)priceAndPay{
    if (!_priceAndPay) {
        if(!self.pay_status){
            _priceAndPay = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"￥%@元（未支付）",@(self.price)] lightRange:@"（未支付）" lightColor:THEME_COLOR];
        }else{
            _priceAndPay = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"￥%@元（已支付）",@(self.price)] lightRange:@"" lightColor:GREEN_COLOR];
        }
    }
    return _priceAndPay;
}


@end

@implementation XYPICCOrderDetail
- (void)setEngineer_remark:(NSString *)engineer_remark{
    _engineer_remark = [[engineer_remark gtm_stringByUnescapingFromHTML] copy];
}
@end
