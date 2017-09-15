//
//  XYCompleteOrderPlatformFeeCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderPlatformFeeCell.h"

@interface XYCompleteOrderPlatformFeeCell()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userOrderPriceLabel;
//图标

@property (weak, nonatomic) IBOutlet UIImageView *recycleIcon;
@property (weak, nonatomic) IBOutlet UILabel *afterSaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *insuranceIcon;
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *vipIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIconLeading;
@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *feePriceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImgView;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *statusLabelLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectImgViewWidth;

@end

@implementation XYCompleteOrderPlatformFeeCell

- (void)awakeFromNib {
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

+ (NSString*)defaultIdentifier{
    return @"XYCompleteOrderPlatformFeeCell";
}

+ (CGFloat)getHeight{
    return 96;
}

-(void)setPlatformFeeDto:(XYAllTypeOrderDto *)platformFeeDto {
    _platformFeeDto = platformFeeDto;
    
    if (_platformFeeDto.platform_pay_status==XYPlatformPayStatusPaid || _platformFeeDto.platform_pay_status==XYPlatformPayStatusNoExist) {
        self.statusLabelLeading.constant = 0;
        self.selectImgViewWidth.constant = 0;
        self.selectedImgView.hidden = YES;
    } else if (_platformFeeDto.platform_pay_status==XYPlatformPayStatusUnpaid) {
        self.statusLabelLeading.constant = 10;
        self.selectImgViewWidth.constant = 15;
        self.selectedImgView.hidden = NO;
    }
    
    //图标
    self.afterSaleLabel.hidden = (_platformFeeDto.order_status!=XYOrderTypeAfterSales);
    self.recycleIcon.hidden = true;
    self.insuranceIcon.hidden = true;
    
    self.vipIcon.hidden = !_platformFeeDto.isVip;
    //调整图标位置（vip图标和售后图标可能共存）
    if (self.afterSaleLabel.hidden) {
        self.vipIconLeading.constant = 10;
    }else{
        self.vipIconLeading.constant = 54;
    }
    //文字
    self.dateLabel.text= XY_NOTNULL(_platformFeeDto.finishTimeString, @"完成时间");
    self.statusLabel.text = _platformFeeDto.statusString;
    
    self.deviceLabel.text = XY_NOTNULL(_platformFeeDto.MouldName, @"设备类型");
    self.userOrderPriceLabel.text = [NSString stringWithFormat:@"%ld元", (long)_platformFeeDto.TotalAccount];
    self.feePriceLabel.text = [NSString stringWithFormat:@"(%@¥%.2f元)", _platformFeeDto.platform_pay_status_name,[_platformFeeDto.platform_fee floatValue]];
    if (_platformFeeDto.platform_pay_status==XYPlatformPayStatusNoExist) {
        self.feePriceLabel.hidden = YES;
    }else {
        self.feePriceLabel.hidden = NO;
    }
    
    self.paymentNameLabel.text = _platformFeeDto.payment_name;
    
    if (_platformFeeDto.platform_fee_selected) {
        self.selectedImgView.image = [UIImage imageNamed:@"gouxuan_cur"];
    }else {
        self.selectedImgView.image = [UIImage imageNamed:@"gouxuan"];
    }
}

- (IBAction)select:(id)sender {
    
    !_selectBlock ?: _selectBlock(self.rowNo);
}

@end
