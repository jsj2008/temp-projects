//
//  XYPoolOrderListMapCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPoolOrderListMapCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYPoolOrderListMapCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIButton *orderActionButton;
@property (weak, nonatomic) IBOutlet UILabel *engineerPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;

@end


@implementation XYPoolOrderListMapCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.orderActionButton.layer.masksToBounds = true;
    self.orderActionButton.layer.cornerRadius = 20.0f;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.orderActionButton setBackgroundColor:THEME_COLOR];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYPoolOrderListMapCell";
}

+ (CGFloat)getHeight{
    return 192;
}

- (void)setPoolOrderData:(XYOrderBase*)data{
    
    if (!data) {
        return;
    }
    
    self.orderIdLabel.text = XY_NOTNULL(data.id, @"");
    self.bidLabel.text = [NSString stringWithFormat:@"%@",@(data.bid)];
    self.nameLabel.text = XY_NOTNULL(data.uName, @"客户姓名");
    self.timeLabel.text = XY_NOTNULL(data.repairTimeString, @"预约时间");
    self.addressLabel.text = XY_NOTNULL(data.address, @"地址");
    self.remarkLabel.text = data.iHaveEnoughParts?@"您满足零件要求可以接单":@"零件不足";
    [self.orderActionButton setTitle:@"接单" forState:UIControlStateNormal];
    self.orderActionButton.tag = XYPoolOrderListMapCellTypePool;
    
    self.orderIdLabel.textColor = WHITE_COLOR;

}

- (void)setOverTimeOrderData:(XYOrderBase*)data{
    
    if (!data) {
        return;
    }
    
    self.orderIdLabel.text = XY_NOTNULL(data.id, @"");
    self.bidLabel.text = [NSString stringWithFormat:@"%@",@(data.bid)];
    self.nameLabel.text = [NSString stringWithFormat:@"%@  %@",data.eng_realName,data.eng_name];
    self.timeLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"%@  超时%@",data.repairTimeString,data.overTimeString] lightRange:[NSString stringWithFormat:@"超时%@",data.overTimeString] lightColor:THEME_COLOR];
    self.addressLabel.text = XY_NOTNULL(data.address, @"地址");
    self.remarkLabel.text = data.iHaveEnoughParts?@"您满足零件要求可以接单":@"零件不足";
    [self.orderActionButton setTitle:@"联系工程师" forState:UIControlStateNormal];
    self.engineerPhoneLabel.text = XY_NOTNULL(data.eng_mobile, @"");
    self.orderActionButton.tag = XYPoolOrderListMapCellTypeOvertime;
    
    self.orderIdLabel.textColor = BLACK_COLOR;
}

- (IBAction)btnClicked:(id)sender {
    if (self.delegate) {
        switch (self.orderActionButton.tag) {
            case XYPoolOrderListMapCellTypePool:
                if ([self.delegate respondsToSelector:@selector(acceptOrder:bid:)]) {
                    [self.delegate acceptOrder:self.orderIdLabel.text bid:[self.bidLabel.text integerValue]];
                }
                break;
            case XYPoolOrderListMapCellTypeOvertime:
                if ([self.delegate respondsToSelector:@selector(callEngineer:)]) {
                    [self.delegate callEngineer:self.engineerPhoneLabel.text];
                }
                break;
            default:
                break;
        }
        
    }
}

@end
