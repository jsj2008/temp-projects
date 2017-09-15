//
//  XYClearedOrderCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYClearedOrderCell.h"
#import "XYConfig.h"

static NSString *const XYClearedOrderCellIdentifier = @"XYClearedOrderCellIdentifier";

@interface XYClearedOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;

@property (weak, nonatomic) IBOutlet UIImageView *insuranceIcon;
@property (weak, nonatomic) IBOutlet UILabel *afterSaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recycleIcon;
@property (weak, nonatomic) IBOutlet UILabel *vipIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIconLeading;

@end


@implementation XYClearedOrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.afterSaleLabel.layer.cornerRadius = 4.0f*LINE_HEIGHT;
    self.afterSaleLabel.textColor = THEME_COLOR;
    self.afterSaleLabel.layer.borderColor = THEME_COLOR.CGColor;
    self.afterSaleLabel.layer.borderWidth = LINE_HEIGHT;
    self.vipIcon.layer.borderWidth = LINE_HEIGHT;
    self.vipIcon.layer.borderColor = XY_HEX(0x1787ff).CGColor;
    self.vipIcon.layer.cornerRadius = 4.0f*LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultIdentifier{
    return XYClearedOrderCellIdentifier;
}

+ (CGFloat)getHeight{
    return 68;
}


- (void)setAllTypeOrder:(XYAllTypeOrderDto*)data{
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
    self.insuranceIcon.hidden = true;
    self.recycleIcon.hidden = true;
    self.afterSaleLabel.hidden = (data.order_status!=XYOrderTypeAfterSales);
    self.vipIcon.hidden = !data.isVip;
    //调整图标位置（vip图标和售后图标可能共存）
    if (self.afterSaleLabel.hidden) {
        self.vipIconLeading.constant = 10;
    }else{
        self.vipIconLeading.constant = 54;
    }
    //文字
    self.dateLabel.text=XY_NOTNULL(data.finishTimeString, @"完成时间");
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.faultLabel.text = XY_NOTNULL(data.FaultTypeDetail,@"故障类型");
}


- (void)setPICCOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.insuranceIcon.hidden = false;
    self.recycleIcon.hidden = true;
    self.afterSaleLabel.hidden = true;
    self.vipIcon.hidden = true;
    //文字
    self.dateLabel.text= XY_NOTNULL(data.finishTimeString, @"确认支付时间");
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.faultLabel.text = @"保险订单";
}

- (void)setRecycleOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.insuranceIcon.hidden = true;
    self.recycleIcon.hidden = false;
    self.afterSaleLabel.hidden = true;
    self.vipIcon.hidden = true;
    //文字
    self.dateLabel.text= XY_NOTNULL(data.finishTimeString, @"完成时间");
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.faultLabel.text = @"回收订单";
}

@end
