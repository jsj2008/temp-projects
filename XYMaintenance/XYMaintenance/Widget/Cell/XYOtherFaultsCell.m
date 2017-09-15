//
//  XYOtherFaultsCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOtherFaultsCell.h"

@implementation XYOtherFaultsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYOtherFaultsCell";
}

- (void)setFaultSelected:(BOOL)selected{
    if (selected) {
        self.faultIndicatorView.image = [UIImage imageNamed:@"order_other_fault"];
    }else{
        self.faultIndicatorView.image = [UIImage imageNamed:@"order_no_fault"];
    }
}


@end
