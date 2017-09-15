//
//  CusAnnotationView.m
//  MAMapKit_static_demo
//
//  Created by songjian on 13-10-16.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CusAnnotationView.h"
#import "XYConfig.h"

@interface CusAnnotationView ()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation CusAnnotationView
@synthesize nameLabel           = _nameLabel;


#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self){
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        =  BLACK_COLOR;
        self.nameLabel.font             =  SMALL_TEXT_FONT;
        self.nameLabel.text = @"点击选中该位置";
        CGSize size = [self.nameLabel.text sizeWithAttributes:@{NSFontAttributeName:self.nameLabel.font}];
        self.nameLabel.frame = CGRectMake(0, 5 + (20 - size.height)/2, size.width + 20, size.height);
        
        self.bounds = CGRectMake(0.f, 0.f, size.width + 20, 39);
        self.backgroundColor = [UIColor clearColor];
        
        CALayer* imgLayer = [CALayer layer];
        imgLayer.frame = self.bounds;
        imgLayer.contents = (id)[UIImage imageNamed:@"bg_map_pop"].CGImage;
        [self.layer addSublayer:imgLayer];
        
        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end
