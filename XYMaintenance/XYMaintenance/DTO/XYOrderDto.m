//
//  XYOrderDto.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYOrderDto.h"
#import "XYStringUtil.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "XYConfig.h"
#import "XYOrderListManager.h"
#import "MJExtension.h"
#import "XYDtoTransferer.h"


@implementation XYOrderBase

- (BOOL)isToday{
    NSDate* onlineDate = [NSDate dateWithTimeIntervalSince1970:[self.reserveTime2 doubleValue]];
    return [onlineDate isSameDay:[NSDate date]];
}

- (XYOrderStatus)status{
    if (_status == XYOrderStatusRepairing) {
        _status = XYOrderStatusOnTheWay;//默认维修中就是已出发
    }
    return _status;
}

- (NSString*)statusString{
    if ([XYStringUtil isNullOrEmpty:_statusString]) {
        _statusString = [XYOrderBase getStatusString:self.status];
    }
    return _statusString;
}

+ (NSString*)getStatusString:(XYOrderStatus)status{
    switch (status) {
        case XYOrderStatusSubmitted:
            return @"已预约";
        case XYOrderStatusRepairing:
        case XYOrderStatusOnTheWay:
            return @"已出发";
        case XYOrderStatusShopRepairing:
            return @"门店维修中";
        case XYOrderStatusCancelled:
            return @"已取消";
        case XYOrderStatusRepaired:
            return @"维修完成";
        case XYOrderStatusDone:
            return @"订单完成";
        default:
            break;
    }
    return @"";
}

- (NSMutableArray*)rightUtilityButtons{
    if (!_rightUtilityButtons) {
        _rightUtilityButtons = [XYOrderBase getRightUtilityButtonsByStatus:self.status payStatus:self.payStatus bid:self.bid];
    }
    return _rightUtilityButtons;
}

+ (NSMutableArray*)getRightUtilityButtonsByStatus:(XYOrderStatus)status payStatus:(BOOL)payStatus bid:(XYBrandType)bid{
    NSMutableArray* rightUtilityButtons = [[NSMutableArray alloc]init];
    switch (status) {
        case XYOrderStatusSubmitted:
            [rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0xcccccc) title:@"取消订单"];
            [rightUtilityButtons sw_addUtilityButtonWithColor:THEME_COLOR title:@"出发"];
            break;
        case XYOrderStatusRepairing:
        case XYOrderStatusOnTheWay:
            [rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0xcccccc) title:@"取消订单"];
            [rightUtilityButtons sw_addUtilityButtonWithColor:THEME_COLOR title:payStatus?@"订单完成":@"维修完成"];
            [rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0x00c3f5) title:@"门店维修"];
            break;
        case XYOrderStatusShopRepairing:
            [rightUtilityButtons sw_addUtilityButtonWithColor:THEME_COLOR title:payStatus? @"订单完成":@"维修完成"];
            break;
        case XYOrderStatusRepaired:
//现金支付
            if(!payStatus){
                XYPayOpenModel* model = [[XYOrderListManager sharedInstance].payOpenMap objectForKey:[NSString stringWithFormat:@"%@",@(bid)]];
                //现金支付
                [rightUtilityButtons sw_addUtilityButtonWithColor:model.cashpay?THEME_COLOR:XY_HEX(0xd9dde4) title:@"现金支付" disable:!model.cashpay];
                if (model.anotherpayweixin ||model.anotherpayalipay) {
                    //如果有某一个代付可用 加入代付按钮
                    [rightUtilityButtons sw_addUtilityButtonWithColor:THEME_COLOR  title:@"代付"];
                }
            }
            break;
        default:
            break;
    }
    for (UIButton* btn in rightUtilityButtons) {
        btn.titleLabel.numberOfLines = 0; //折行
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);//边距
    }
    return rightUtilityButtons;
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

- (NSString*)overTimeString{
    NSTimeInterval interval = [[NSDate date]timeIntervalSince1970] - [self.reserveTime2 doubleValue];
    return [NSString stringWithFormat:@"%@分钟",@((NSInteger)(MAX(interval, 0)/60))];
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

//+ (NSString*)getPaymentDes:(XYPaymentType)payment{
//    switch (payment) {
//        case XYPaymentTypePaidByCash:
//            return @"现金支付";
//        case XYPaymentTypeWechat:
//            return @"微信扫码";
//        case XYPaymentTypeAlipay:
//            return @"支付宝扫码";
//        case XYPaymentTypeWechatAPP:
//        case XYPaymentTypeAlipayAPP:
//            return @"用户APP支付";
//        case XYPaymentTypeWorkerWechat:
//            return @"微信代付";
//        case XYPaymentTypeWorkerAlipay:
//            return @"支付宝代付";
//        case XYPaymentTypeDaoWei:
//            return @"到位支付";
//        case XYPaymentTypePICC:
//            return @"PICC支付";
//        case XYPaymentTypeXPZBT:
//            return @"小浦周边通";
//        case XYPaymentTypeCMB:
//            return @"招行一网通";
//        case XYPaymentTypeZhongWei:
//            return @"众维支付";
//        case XYPaymentTypeSanTi:
//            return @"三体科技";
//        case XYPaymentTypeTaobao:
//            return @"淘宝支付";
//        case XYPaymentTypePutao:
//            return @"葡萄生活";
//        case XYPaymentTypeYuhang:
//            return @"余杭人保";
//        default:
//            return @"其它";
//            break;
//    }
//}

+ (NSString*)getPaymentIconName:(XYPaymentType)payment{
    switch (payment) {
        case XYPaymentTypeDaoWei:
            return @"pay_daowei";
        case XYPaymentTypePICC:
            return @"pay_picc";
        case XYPaymentTypeXPZBT:
            return @"pay_xiaopu";
        case XYPaymentTypeCMB:
            return @"pay_cmb";
        case XYPaymentTypeZhongWei:
            return @"pay_zhongwei";
        case XYPaymentTypeSanTi:
            return @"pay_santi";
        case XYPaymentTypeTaobao:
            return @"pay_taobao";
        case XYPaymentTypePutao:
            return @"pay_putao";
        case XYPaymentTypeYuhang:
            return @"pay_yuhang";
        default:
            return nil;
            break;
    }
}

//- (NSString*)paymentDes{
//    return [XYOrderBase getPaymentDes:self.payment];
//}

+ (XYOrderStatus)getClickedActionStatus:(XYOrderStatus)currentStatus rightBtnIndex:(NSInteger)index{
    switch (currentStatus){
        case XYOrderStatusSubmitted:
            switch (index) {
                case 0:
                    return XYOrderStatusCancelled;
                case 1:
                    return XYOrderStatusOnTheWay;
                default:
                    return XYOrderStatusNothing;
            }
        case XYOrderStatusOnTheWay:
            switch (index) {
                case 0:
                    return XYOrderStatusCancelled;
                case 1:
                    return XYOrderStatusRepaired;
                case 2:
                    return XYOrderStatusShopRepairing;
                default:
                    return XYOrderStatusNothing;
            }
            break;
        case XYOrderStatusShopRepairing:
            return XYOrderStatusRepaired;
            break;
        case XYOrderStatusCancelled:
            return XYOrderStatusDeleted;
            break;
        default:
            return XYOrderStatusNothing;
            break;
    }
}



//+ (XYOrderBase*)convertPICCOrder:(XYPICCOrderDto*)piccOrder{
//    
//    if (!piccOrder) {
//        return nil;
//    }
//    
//    XYOrderBase* orderBase = [[XYOrderBase alloc]init];
//    orderBase.isPICCOrder = true;
//    orderBase.picc_odd_number = piccOrder.odd_number;
//    orderBase.uName = piccOrder.user_name;
//    orderBase.uMobile = piccOrder.user_mobile;
//    orderBase.picc_related_order_id = piccOrder.order_id;
//    orderBase.TotalAccount = piccOrder.price;
//    orderBase.MouldName = piccOrder.mould_name;
//    orderBase.picc_status = piccOrder.status;
//    orderBase.picc_pay_status = piccOrder.pay_status;
//    orderBase.picc_priceAndPay = piccOrder.priceAndPay;
//    orderBase.picc_statusStr = piccOrder.statusStr;
//    orderBase.picc_confirmed_time = piccOrder.confirm_pay_dt;
//    return orderBase;
//}

@end



@implementation XYOrderDetail

-(NSString*)createTimeString{
    if ([XYStringUtil isNullOrEmpty:_createTimeString]) {
        _createTimeString =[[NSDate dateWithTimeIntervalSince1970:[self.createTime doubleValue]] formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _createTimeString;
}

-(NSString*)wareHouseString{
    if ([XYStringUtil isNullOrEmpty:_wareHouseString]) {
        _wareHouseString = self.bill_type?@"外仓":@"内仓";
    }
    return _wareHouseString;
}

@end

@implementation XYPHPCommentDetail
@end
@implementation XYPHPReplyDetail
@end


@implementation XYPHPCommentDto

- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        return self.message;
    }
}

-(NSInteger)stars{
    return 0;
}

-(NSString*)commentTime{
    if ([XYStringUtil isNullOrEmpty:_commentTime]) {
        _commentTime = [[NSDate dateWithTimeIntervalSince1970:[self.comment.CreateTime doubleValue]]formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _commentTime;
}

-(NSString*)replyTime{
    if ([XYStringUtil isNullOrEmpty:_replyTime]) {
        _replyTime = [[NSDate dateWithTimeIntervalSince1970:[self.reply.CreateTime doubleValue]]formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _replyTime;
}
@end

@implementation XYPayServiceCode
@end

@implementation XYOrderCount
@end

@implementation XYRemindInfo
@end

@implementation XYRemindOrderDto
@end


@implementation XYOrderMessageDto
@end


@implementation XYCancelOrderDto
@end


@implementation XYCancelOrderListDto

@end

@implementation XYRepairSelections
+ (NSArray*)repairSelectionTitlesArray{
    return @[@"是否有维修拆机历史",@"是否有缺少零件",@"是否有受潮或进水",@"是否有摔伤或挤压变形",@"是否有旧配件带回",@"是否回收手机",@"手机功能是否正常"];
}
+ (NSArray*)repairSelectionParamsArray{
    return @[@"is_fixed",@"is_miss",@"is_wet",@"is_deformed",@"is_recycle",@"is_used",@"is_normal"];
}
@end

@implementation XYColorDto
@end

