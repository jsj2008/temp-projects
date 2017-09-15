//
//  XYSimpleTextField.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSimpleTextField.h"

@implementation XYSimpleTextField

/**
 *  hook 左边留白缩进+10
 */
- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += 2;
    return iconRect;
}

/**
 *  leftView是文字label
 */
- (void)setLeftString:(NSString*)str{
    UILabel* leftLabel = [[UILabel alloc]init];
    leftLabel.font = [UIFont systemFontOfSize:13.0f];
    leftLabel.text = str;
    CGSize strSize = [str sizeWithAttributes:@{NSFontAttributeName:leftLabel.font}];
    leftLabel.frame = CGRectMake(0, 0, strSize.width, strSize.height);
    self.leftView = leftLabel;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

/**
 *   leftView是图片
 */
- (void)setLeftImage:(UIImage*)img{
    UIImageView* leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 41, 21)];
    leftImageView.image = img;
    leftImageView.contentMode = UIViewContentModeCenter;
    self.leftView = leftImageView;
    self.leftViewMode = UITextFieldViewModeAlways;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
