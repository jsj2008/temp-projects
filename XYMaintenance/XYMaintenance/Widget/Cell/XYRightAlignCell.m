//
//  XYRightAlignCell.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/13.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYRightAlignCell.h"

@implementation XYRightAlignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYRightAlignCell";
}

@end
