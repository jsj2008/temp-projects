//
// Created by Shaokang Zhao on 15/1/12.
// Copyright (c) 2015 Shaokang Zhao. All rights reserved.
//

#import "SKTagButton.h"
#import "SKTag.h"

@implementation SKTagButton

+ (instancetype)buttonWithTag: (SKTag *)tag {
	SKTagButton *btn = [super buttonWithType:UIButtonTypeCustom];
    [btn addSubview: btn.deleteView];
    
	if (tag.attributedText) {
		[btn setAttributedTitle: tag.attributedText forState: UIControlStateNormal];
	} else {
		[btn setTitle: tag.text forState:UIControlStateNormal];
		[btn setTitleColor: tag.textColor forState: UIControlStateNormal];
		btn.titleLabel.font = tag.font ?: [UIFont systemFontOfSize: tag.fontSize];
	}
	
	btn.backgroundColor = tag.bgColor;
	btn.contentEdgeInsets = tag.padding;
	btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    if (tag.bgImg) {
        [btn setBackgroundImage: tag.bgImg forState: UIControlStateNormal];
    }
    
    if (tag.borderColor) {
        btn.layer.borderColor = tag.borderColor.CGColor;
    }
    
    if (tag.borderWidth) {
        btn.layer.borderWidth = tag.borderWidth;
    }
    
    btn.userInteractionEnabled = tag.enable;
    if (tag.enable) {
        UIColor *highlightedBgColor = tag.highlightedBgColor ?: [self darkerColor:btn.backgroundColor];
        [btn setBackgroundImage:[self imageWithColor:highlightedBgColor] forState:UIControlStateHighlighted];
    }
    
    btn.layer.cornerRadius = tag.cornerRadius;
    //btn.layer.masksToBounds = YES;
    
    btn.tag = tag.tagId;//按钮的标签数字
    
    return btn;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

+ (UIColor *)darkerColor:(UIColor *)color {
    CGFloat h, s, b, a;
    if ([color getHue:&h saturation:&s brightness:&b alpha:&a])
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b * 0.85
                               alpha:a];
    return color;
}

- (UIImageView*)deleteView{
    if (!_deleteView) {
        _deleteView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"delete"]];
    }
    return _deleteView;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.deleteView.frame = CGRectMake(self.frame.size.width - self.deleteView.frame.size.width/2 - 1, (-0.5)*self.deleteView.frame.size.height + 1, self.deleteView.frame.size.width, self.deleteView.frame.size.height);
}

@end
