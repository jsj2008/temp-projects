//
//  XYCustomButton.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYCustomButton.h"
#import "XYConfig.h"

@implementation XYCustomButton

#pragma mark - init

- (id)init{
    if (self = [super init]){
        [self configAppearance];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self configAppearance];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]){
        [self configAppearance];
    }
    return self;
}

#

- (void)configAppearance{
    self.superview?:[self layoutIfNeeded];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = (self.frame.size.height>0)?self.frame.size.height/2:20.0f;
    [self setButtonEnable:true];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

- (void)setButtonEnable:(BOOL)enabled{
    self.enabled = enabled;
    self.backgroundColor = enabled? THEME_COLOR:XY_COLOR(217, 221, 228);
}

- (void)layoutIfNeeded{
    [super layoutIfNeeded];
    self.layer.masksToBounds = true;
    self.layer.cornerRadius = (self.frame.size.height>0)?self.frame.size.height/2:20.0f;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
