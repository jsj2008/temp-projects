//
//  XYBonusCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBonusCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

static NSString *const XYBonusCellIdentifier = @"XYBonusCellIdentifier";

@interface XYBonusCell ()
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *bonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@end

@implementation XYBonusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bonusLabel.textColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight{
    return 70;
}

+ (NSString*)defaultIdentifier{
    return XYBonusCellIdentifier;
}

- (void)setRepairBonusData:(XYBonusDetailDto*)data{
    
    if (!data) {
        return;
    }
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备名称");
    self.faultLabel.text = XY_NOTNULL(data.FaultType, @"故障名称");
    self.timeLabel.text = XY_NOTNULL(data.FinishTimeStr, @"维修完成时间");
    self.bonusLabel.text = [NSString stringWithFormat:@"%@%g",(data.pushMoney>=0)?@"+":@"",data.pushMoney];
    self.noteLabel.text = XY_NOTNULL(data.remark, @"");
    if ([XYStringUtil isNullOrEmpty:data.remark]) {
        self.orderIdLabel.text = @"";
    }else{
        self.orderIdLabel.text = [NSString stringWithFormat:@"订单：%@",data.id];
    }
    
}

- (void)setPICCBonusData:(XYPICCBonusDto*)data{
    if (!data) {
        return;
    }
    self.deviceLabel.text = XY_NOTNULL(data.mould_name, @"设备名称");
    self.faultLabel.text = XY_NOTNULL(data.coverage_name, @"保险");
    self.timeLabel.text = XY_NOTNULL(data.valid_dt, @"结算时间");
    self.bonusLabel.text = [NSString stringWithFormat:@"+%g",data.push_money];
    self.noteLabel.text = @"";
    self.orderIdLabel.text = @"";
}

- (void)setRecycleBonusData:(XYRecycleBonusDto*)data{
    if (!data) {
        return;
    }
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备名称");
    self.faultLabel.text = @"回收订单";
    self.timeLabel.text = @"";//??
    self.bonusLabel.text = [NSString stringWithFormat:@"+%g",data.pushMoney];
    self.noteLabel.text = @"";
    self.orderIdLabel.text = @"";
}

- (void)setPromotionBonusData:(XYPromotionBonusDetail*)data{

    if (!data) {
        return;
    }
    self.deviceLabel.text = XY_NOTNULL(data.sourceStr, @"推广类型");
    self.faultLabel.text = @"";
    self.timeLabel.text = XY_NOTNULL(data.recordTimeStr, @"推广时间");
    self.bonusLabel.text = [NSString stringWithFormat:@"+%g",data.push_money];
    self.noteLabel.text = @"";
    self.orderIdLabel.text = @"";
}

@end
