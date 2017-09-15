//
//  XYCompleteOrderCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderCell.h"
#import "XYConfig.h"

static NSString *const XYCompleteOrderCellIdentifier = @"XYCompleteOrderCellIdentifier";

@interface XYCompleteOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//图标

@property (weak, nonatomic) IBOutlet UIImageView *recycleIcon;
@property (weak, nonatomic) IBOutlet UILabel *afterSaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *vipIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIconLeading;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;

@end

@implementation XYCompleteOrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.afterSaleLabel.layer.cornerRadius = 5.0f*LINE_HEIGHT;
    self.afterSaleLabel.textColor = THEME_COLOR;
    self.afterSaleLabel.layer.borderColor = THEME_COLOR.CGColor;
    self.afterSaleLabel.layer.borderWidth = LINE_HEIGHT;
    self.statusLabel.textColor = THEME_COLOR;
    self.vipIcon.layer.borderWidth = LINE_HEIGHT;
    self.vipIcon.layer.borderColor = XY_HEX(0xDFB772).CGColor;
    self.vipIcon.layer.cornerRadius = 4.0f *LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (NSString*)defaultIdentifier{
    return XYCompleteOrderCellIdentifier;
}

+ (CGFloat)getHeight{
    return 96;
}

- (void)setAllTypeOrderData:(XYAllTypeOrderDto*)data{
    if (!data) {
        return;
    }
    
    switch (data.type) {
        case XYAllOrderTypeRepair:
            [self setRepairOrderData:data];
            break;
        case XYAllOrderTypeInsurance:
            [self setPICCOrderData:data];
            break;
        case XYAllOrderTypeRecycle:
            [self setRecycleOrderData:data];
            break;
        default:
            break;
    }
}

- (void)setRepairOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.afterSaleLabel.hidden = (data.order_status!=XYOrderTypeAfterSales);
    self.recycleIcon.hidden = true;
    self.insuranceIcon.hidden = true;
//    self.payIcon.image = [UIImage imageNamed:data.payIconName?:@"order_price"];
    self.vipIcon.hidden = !data.isVip;
    //调整图标位置（vip图标和售后图标可能共存）
    if (self.afterSaleLabel.hidden) {
        self.vipIconLeading.constant = 10;
    }else{
        self.vipIconLeading.constant = 54;
    }
    //文字
    self.dateLabel.text= XY_NOTNULL(data.finishTimeString, @"完成时间");
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.priceLabel.attributedText = data.priceAndPay;
    self.paymentNameLabel.text = data.payment_name;
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}

- (void)setPICCOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.afterSaleLabel.hidden = true;
    self.recycleIcon.hidden = true;
    self.insuranceIcon.hidden = false;
    self.payIcon.image = [UIImage imageNamed:data.payIconName?:@"order_price"];
    self.vipIcon.hidden = true;
    //文字
    self.dateLabel.text= XY_NOTNULL(data.id, @"保险单号");
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.priceLabel.attributedText = data.priceAndPay;
    self.paymentNameLabel.text = data.payment_name;
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}

- (void)setRecycleOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.insuranceIcon.hidden = true;
    self.recycleIcon.hidden = false;
    self.afterSaleLabel.hidden = true;
    self.payIcon.image = [UIImage imageNamed:data.payIconName?:@"order_price"];
    self.vipIcon.hidden = true;
    //文字
    self.dateLabel.text= XY_NOTNULL(data.id, @"回收单号");
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.priceLabel.attributedText = data.priceAndPay;
    self.paymentNameLabel.text = XY_NOTNULL(data.payment_name, @"支付方式");
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}

@end
