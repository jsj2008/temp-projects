//
//  XYStarCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYStarCell.h"

@implementation XYStarCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.rateView.userInteractionEnabled = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYStarCell";
}

- (IBAction)clickStarButton:(id)sender {
    !_clickStarButtonBlock ?: _clickStarButtonBlock();
}

@end
