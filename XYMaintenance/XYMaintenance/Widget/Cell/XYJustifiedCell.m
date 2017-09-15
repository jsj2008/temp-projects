//
//  XYJustifiedCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYJustifiedCell.h"
#import "XYConfig.h"

@implementation XYJustifiedCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
//    self.titleLabelView.lineHeightScale = 0.65;
//    self.titleLabelView.fdLineScaleBaseLine = FDLineHeightScaleBaseLineTop;
//    self.titleLabelView.fdTextAlignment = FDTextAlignmentFill;
//    self.titleLabelView.fdAutoFitMode = FDAutoFitModeContrainedFrame;
//    self.titleLabelView.fdLabelFitAlignment = FDLabelFitAlignmentCenter;
//    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabelView.font = SIMPLE_TEXT_FONT;
    self.titleLabelView.textColor = LIGHT_TEXT_COLOR;
    self.xyTextField.font = SIMPLE_TEXT_FONT;
    self.xyTextField.textColor = BLACK_COLOR;
    self.xyTextField.placeholder = @"";
}


+ (CGFloat)defaultHeight{
    return 45;
}

+ (NSString*)defaultReuseId{
   return @"XYJustifiedCell";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
