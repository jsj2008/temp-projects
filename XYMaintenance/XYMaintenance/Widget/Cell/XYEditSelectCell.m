//
//  XYEditSelectCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYEditSelectCell.h"

static NSString *const XYEditSelectCellIdentifier = @"XYEditSelectCellIdentifier";


@implementation XYEditSelectCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return XYEditSelectCellIdentifier;
}



@end
