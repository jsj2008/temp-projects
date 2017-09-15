//
//  XYArrowDownButton.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/28.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYArrowDownButton.h"

@implementation XYArrowDownButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //1.
    CGRect frame = self.frame;
    
    //3. imageView布局
    self.imageView.frame = CGRectMake(CGRectGetMaxX(frame) - self.imageView.frame.size.width - 5, 0, self.imageView.frame.size.width, self.imageView.frame.size.height);
    
    //2. titleLabel布局
    self.titleLabel.frame = CGRectMake(0, 0 , self.imageView.frame.origin.x - 5, frame.size.height);
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
