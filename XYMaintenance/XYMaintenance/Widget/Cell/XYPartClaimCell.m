//
//  XYPartClaimCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/23.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartClaimCell.h"
#import "XYStringUtil.h"

static NSString *const XYPartClaimCellIdentifier = @"XYPartClaimCellIdentifier";

@implementation XYPartClaimCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.deviderHeight.constant = LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (CGFloat)getHeight:(BOOL)folded{
    return folded ? 40:100;
}


+ (NSString*)defaultIdentifier{
    return XYPartClaimCellIdentifier;
}

- (void)setData:(XYPartRecordDto*)data{
    if (!data) {
        return;
    }
    
    self.dateLabel.text = data.recordTimeStr;
    NSString* countStrr = [NSString stringWithFormat:@"配件数量：%@个",@(data.total_num)];
    self.countLabel.attributedText = [XYStringUtil getAttributedStringFromString:countStrr lightRange:[NSString stringWithFormat:@"%@个",@(data.total_num)] lightColor:THEME_COLOR];
    self.deviderLine.hidden=self.confirmButton.hidden = data.is_receive;
}

@end
