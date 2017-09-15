//
//  XYOrderDetailTopCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYOrderDetailTopCell.h"
#import "XYConfig.h"

static NSString *const XYOrderDetailTopCellIdentifier = @"XYOrderDetailTopCellIdentifier";


@implementation XYOrderDetailTopCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.statusLabel.textColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString*)defaultReuseId{
    return XYOrderDetailTopCellIdentifier;
}

@end
