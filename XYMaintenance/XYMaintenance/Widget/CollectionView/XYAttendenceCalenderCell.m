//
//  XYAttendenceCalenderCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/9/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAttendenceCalenderCell.h"
#import "XYConfig.h"

@implementation XYAttendenceCalenderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.absenceLabel.hidden = true;
}

+ (NSString*)defaultReuseId{
    return @"XYAttendenceCalenderCell";
}

- (void)setTitle:(NSString*)titleStr{
    self.dateLabel.text = titleStr?titleStr:@"";
    self.dateLabel.textColor = BLACK_COLOR;
    self.absenceLabel.hidden = true;
    self.contentView.backgroundColor = WHITE_COLOR;
}

- (void)setDate:(NSInteger)date isThisMonth:(BOOL)thisMonth isAbsence:(BOOL)absence isLeave:(BOOL)isLeave isSelected:(BOOL)selected{
    self.dateLabel.text = [NSString stringWithFormat:@"%@",@(date)];
    self.dateLabel.textColor = isLeave?WHITE_COLOR:(thisMonth?BLACK_COLOR:XY_HEX(0xcccccc));
    self.absenceLabel.hidden = !absence;
    self.contentView.backgroundColor = selected?XY_HEX(0xeef0f3):(isLeave?THEME_COLOR:WHITE_COLOR);
}
@end
