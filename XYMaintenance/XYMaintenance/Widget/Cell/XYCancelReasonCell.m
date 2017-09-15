//
//  XYCancelReasonCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/4/11.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCancelReasonCell.h"

@implementation XYCancelReasonCell

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
   return @"XYCancelReasonCell";
}

+ (CGFloat)defaultHeight{
    return 37;
}

- (void)setXYSelected:(BOOL)selected{
    self.xyImageView.image = [UIImage imageNamed:selected?@"btn_cancel_order":@"bg_cancel"];
}




@end
