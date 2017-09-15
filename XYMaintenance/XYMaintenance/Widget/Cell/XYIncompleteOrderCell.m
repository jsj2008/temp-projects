//
//  XYIncompleteOrderCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYIncompleteOrderCell.h"
#import "XYConfig.h"
#import "NSDate+DateTools.h"
#import "XYStringUtil.h"


static NSString *const XYIncompleteOrderCellIdentifier = @"XYIncompleteOrderCellIdentifier";


@interface XYIncompleteOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *reserveTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *colorIcon;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;

//图标 控制显示隐藏
@property (weak, nonatomic) IBOutlet UIImageView *insuranceIcon;
@property (weak, nonatomic) IBOutlet UILabel *afterSaleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recycleIcon;

@property (weak, nonatomic) IBOutlet UILabel *vipIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vipIconLeading;

@property (weak, nonatomic) IBOutlet UILabel *paymentNameLabel;
@end

@implementation XYIncompleteOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deviderHeight.constant = LINE_HEIGHT;
    self.afterSaleLabel.layer.cornerRadius = 5.0f*LINE_HEIGHT;
    self.afterSaleLabel.textColor = THEME_COLOR;
    self.afterSaleLabel.layer.borderColor = THEME_COLOR.CGColor;
    self.afterSaleLabel.layer.borderWidth = LINE_HEIGHT;
    self.statusLabel.textColor = THEME_COLOR;
    self.vipIcon.layer.borderWidth = LINE_HEIGHT;
    self.vipIcon.layer.borderColor = XY_HEX(0xdfb772).CGColor;
    self.vipIcon.layer.cornerRadius = 4.0f *LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight{
    return 135;
}

+ (NSString*)defaultIdentifier{
    return XYIncompleteOrderCellIdentifier;
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
    self.colorIcon.hidden = false;
    self.colorLabel.hidden = false;
    self.vipIcon.hidden = !data.isVip;
    //调整图标位置（vip图标和售后图标可能共存）
    if (self.afterSaleLabel.hidden) {
        self.vipIconLeading.constant = 10;
    }else{
        self.vipIconLeading.constant = 54;
    }
    
    //文字
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",XY_NOTNULL(data.uName, @"客户姓名"),(data.bid == XYBrandTypeMeizu)?data.order_num:data.id];
    self.reserveTimeLabel.text = XY_NOTNULL(data.repairTimeString, @"预约时间");    

    //预约时早于当前时间，并且状态不是已出发和门店维修中，为红色，否则为正常色。
    NSDate *lastReserveDate;
    if ([data.reserveTime2 isEqualToString:@"0"]|| [XYStringUtil isNullOrEmpty:data.reserveTime2]) {
       lastReserveDate = [NSDate dateWithTimeIntervalSince1970:[data.reserveTime doubleValue]];
    }else {
        lastReserveDate = [NSDate dateWithTimeIntervalSince1970:[data.reserveTime2 doubleValue]];
    }
    if ([lastReserveDate isEarlierThan:[NSDate date]] & (![data.statusString isEqualToString:@"已出发"])& (![data.statusString isEqualToString:@"门店维修中"])) {
        self.reserveTimeLabel.textColor = [UIColor redColor];
    }else {
        self.reserveTimeLabel.textColor = XY_HEX(0x666666);
    }
 
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.colorLabel.text = XY_NOTNULL(data.color, @"颜色");
    self.faultLabel.text = XY_NOTNULL(data.FaultTypeDetail, @"故障类型");
    self.paymentNameLabel.text = data.payment_name;
    //颜色
    self.statusLabel.textColor = [self getRepairStatusLabelColor:data.status];
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}

- (void)setPICCOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.insuranceIcon.hidden = false;
    self.recycleIcon.hidden = true;
    self.afterSaleLabel.hidden = true;
    self.colorIcon.hidden = false;
    self.colorLabel.hidden = false;
    self.vipIcon.hidden = true;
    //文字
    self.nameLabel.text = XY_NOTNULL(data.uName, @"客户姓名");
    self.reserveTimeLabel.text = @"预约时间";
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.colorLabel.text = [NSString stringWithFormat:@"维修订单：%@",XY_NOTNULL(data.origin_order_id,@"无")];
    self.faultLabel.text = [NSString stringWithFormat:@"保险金额：%@",@(data.TotalAccount)];
    //颜色
    self.statusLabel.textColor = THEME_COLOR;
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}

- (void)setRecycleOrderData:(XYAllTypeOrderDto*)data{
    //图标
    self.insuranceIcon.hidden = true;
    self.recycleIcon.hidden = false;
    self.afterSaleLabel.hidden = true;
    self.colorIcon.hidden = true;
    self.colorLabel.hidden = true;
    self.vipIcon.hidden = true;
    //文字
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",XY_NOTNULL(data.uName, @"客户姓名"),data.id];
    self.reserveTimeLabel.text = XY_NOTNULL(data.repairTimeString, @"预约时间");
    self.statusLabel.text = data.statusString;
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.colorLabel.text = XY_NOTNULL(data.color, @"颜色");
    self.faultLabel.text = @"旧品回收";
    self.paymentNameLabel.text = data.payment_name;
    //颜色
    self.statusLabel.textColor = [self getRecycleStatusLabelColor:data.status];
    //左滑按钮
    [self setRightUtilityButtons:data.rightUtilityButtons WithButtonWidth:70];
}


- (UIColor*)getRepairStatusLabelColor:(XYOrderStatus)status{
    if (status == XYOrderStatusOnTheWay || status == XYOrderStatusRepairing) {
        return XY_HEX(0x00b738);
    }else if(status == XYOrderStatusCancelled){
        return XY_HEX(0x999999);
    }
    return THEME_COLOR;
}

- (UIColor*)getRecycleStatusLabelColor:(XYRecycleOrderStatus)status{
    if (status == XYRecycleOrderStatusSetOff) {
        return XY_HEX(0x00b738);
    }else if(status == XYRecycleOrderStatusCancelled){
        return XY_HEX(0x999999);
    }
    return THEME_COLOR;
}


@end
