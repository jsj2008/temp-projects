//
//  XYPartInfoCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartInfoCell.h"
#import "XYConfig.h"

static NSString *const XYPartInfoCellIdentifier = @"XYPartInfoCellIdentifier";

@implementation XYPartInfoCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    self.deviderHeight.constant=LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)getHeight{
    return 111;
}

+ (NSString*)defaultIdentifier{
    return XYPartInfoCellIdentifier;
}


@end
