//
//  SimpleAlignCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "SimpleAlignCell.h"


@implementation SimpleAlignCell
//FD bug fix
//    CGFloat contentViewWidth = 90;
//    NSLayoutConstraint *titleLableWidthConstraint = [NSLayoutConstraint constraintWithItem:self.xyTextLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
//    [self.contentView addConstraint:titleLableWidthConstraint];
- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.xyDetailLabel.lineBreakMode = NSLineBreakByCharWrapping;

    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height == 568) {
        self.xyDetailLabel.preferredMaxLayoutWidth = 170;
    } else if(result.height == 667) {
        self.xyDetailLabel.preferredMaxLayoutWidth = 200;
    } else if(result.height > 667) {
        self.xyDetailLabel.preferredMaxLayoutWidth = 265;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (NSString*)defaultReuseId{
   return @"SimpleAlignCell";
}

- (void)setData:(NSString*)data {
    self.xyDetailLabel.text = data;
}


@end
