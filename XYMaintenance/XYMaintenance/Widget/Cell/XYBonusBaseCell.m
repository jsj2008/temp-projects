//
//  XYBonusBaseCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBonusBaseCell.h"
#import "XYConfig.h"

static NSString *const XYBonusBaseCellIdentifier = @"XYBonusBaseCellIdentifier";

@interface XYBonusBaseCell ()


@property (weak, nonatomic) IBOutlet UILabel *monthBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayBonusLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalBonusLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderWidth1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderWidth2;
@end

@implementation XYBonusBaseCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.deviderWidth1.constant = self.deviderWidth2.constant = LINE_HEIGHT;
    self.monthBonusLabel.textColor = self.todayBonusLabel.textColor = self.totalBonusLabel.textColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight{
    return 65;
}

+ (NSString*)defaultIdentifier{
    return XYBonusBaseCellIdentifier;
}

- (void)setBonusAmountData:(XYBonusDto*)data{
    
    if (!data) {
        return;
    }
    
    self.monthTitleLabel.text = @"本月提成(元)";
    self.dayTitleLabel.text = @"今日提成(元)";
    self.totalTitleLabel.text = @"总提成(元)";
    
    self.monthBonusLabel.text = [NSString stringWithFormat:@"%g ",data.mouth_push_money];
    self.todayBonusLabel.text = [NSString stringWithFormat:@"%g ",data.day_push_money];
    self.totalBonusLabel.text = [NSString stringWithFormat:@"%g ",data.total_push_money];
}


- (void)setBonusCountData:(XYPromotionBonusDto*)data{
    
    if (!data) {
        return;
    }
    
    self.monthTitleLabel.text = @"本月关注量";
    self.dayTitleLabel.text = @"今日关注量";
    self.totalTitleLabel.text = @"总关注量";
    
    self.monthBonusLabel.text = [NSString stringWithFormat:@"%@ ",@(data.countMonth)];
    self.todayBonusLabel.text = [NSString stringWithFormat:@"%@ ",@(data.countDay)];
    self.totalBonusLabel.text = [NSString stringWithFormat:@"%@ ",@(data.countTotal)];

}

@end
