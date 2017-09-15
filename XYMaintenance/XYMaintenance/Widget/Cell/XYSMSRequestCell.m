//
//  XYSMSRequestCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/11/21.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYSMSRequestCell.h"
#import "XYConfig.h"

@implementation XYSMSRequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabelView.font = SIMPLE_TEXT_FONT;
    self.titleLabelView.textColor = LIGHT_TEXT_COLOR;
    self.xyTextField.font = SIMPLE_TEXT_FONT;
    self.xyTextField.textColor = BLACK_COLOR;
    self.xyTextField.placeholder = @"";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYSMSRequestCell";
}

@end
