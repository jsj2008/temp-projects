//
//  XYRouteHeaderView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRouteHeaderView.h"
#import "XYConfig.h"

@implementation XYRouteHeaderView

-(id)init
{
    if (self = [super init])
    {
        _isReversed = false;
        [self initializeUI];
    }
    
    return self;
}

-(void)initializeUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 90);
    
    UIImageView* leftImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_addr"]];
    leftImageView.frame = CGRectMake(14, 15, leftImageView.frame.size.width, leftImageView.frame.size.height);
    [self addSubview:leftImageView];
    
    UIButton* reverseButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 55, 28, 55, 34)];
    [reverseButton setImage:[UIImage imageNamed:@"icon_updown"] forState:UIControlStateNormal];
    [reverseButton addTarget:self action:@selector(reverseAddresses) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:reverseButton];
 
    self.startLocLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 7, SCREEN_WIDTH - 100, 32)];
    self.startLocLabel.textColor = BLACK_COLOR;
    self.startLocLabel.font = LARGE_TEXT_FONT;
    [self addSubview:self.startLocLabel];
    
    UIView* deviderLine = [[UIView alloc]initWithFrame:CGRectMake(45, 45, SCREEN_WIDTH - 100, LINE_HEIGHT)];
    deviderLine.backgroundColor = XY_COLOR(236,240,246);
    [self addSubview:deviderLine];
    
    self.endLocLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 51, SCREEN_WIDTH - 100, 32)];
    self.endLocLabel.textColor = MOST_LIGHT_COLOR;
    self.endLocLabel.font = LARGE_TEXT_FONT;
    [self addSubview:self.endLocLabel];
}

-(void)reverseAddresses
{
    self.isReversed = !self.isReversed;
    
    if (self.isReversed)
    {
        self.endLocLabel.frame = CGRectMake(45, 7, SCREEN_WIDTH - 100, 32);
        self.startLocLabel.frame = CGRectMake(45, 51, SCREEN_WIDTH - 100, 32);
    }
    else
    {
       self.startLocLabel.frame = CGRectMake(45, 7, SCREEN_WIDTH - 100, 32);
       self.endLocLabel.frame = CGRectMake(45, 51, SCREEN_WIDTH - 100, 32);
    }
    if ([self.delegate respondsToSelector:@selector(onReverseButtonClicked)]) {
        [self.delegate onReverseButtonClicked];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
