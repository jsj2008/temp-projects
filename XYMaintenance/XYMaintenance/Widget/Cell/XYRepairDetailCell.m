//
//  XYRepairDetailCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRepairDetailCell.h"
#import "XYConfig.h"

@implementation XYRepairDetailCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.segmentControl.selectedSegmentIndex = -1;
    self.segmentControl.tintColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYRepairDetailCell";
}

+ (CGFloat)defaultHeight{
    return 45;
}


@end
