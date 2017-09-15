//
//  XYTargetLocFooterView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/26.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTargetLocFooterView.h"
#import "XYConfig.h"

@implementation XYTargetLocFooterView

-(id)init
{
    if (self = [super init])
    {
        [self initializeUI];
    }
    
    return self;
}

-(void)initializeUI
{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    self.backgroundColor = WHITE_COLOR;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.layer.shadowOffset = CGSizeMake(0, -7);
    self.layer.shadowColor = LIGHT_TEXT_COLOR.CGColor;
    self.layer.shadowOpacity = 0.2;
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, SCREEN_WIDTH - 30, 25)];
    self.addressLabel.font = SIMPLE_TEXT_FONT;
    self.addressLabel.textColor = BLACK_COLOR;
    self.addressLabel.text = @"联系地址";
    self.addressLabel.numberOfLines = 0;
    self.addressLabel.adjustsFontSizeToFitWidth = true;
    [self addSubview:self.addressLabel];
    
    self.viewRouteButton = [[UIButton alloc]initWithFrame:CGRectMake(15, 55, (SCREEN_WIDTH - 45)/2, 33)];
    self.viewRouteButton.backgroundColor = XY_COLOR(241,245,248);
    [self.viewRouteButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [self.viewRouteButton setTitle:@"查看路线" forState:UIControlStateNormal];
    self.viewRouteButton.titleLabel.font =  SIMPLE_TEXT_FONT;
    self.viewRouteButton.layer.cornerRadius = 3;
    self.viewRouteButton.layer.borderWidth = LINE_HEIGHT;
    self.viewRouteButton.layer.borderColor = XY_COLOR(170,178,196).CGColor;
    self.viewRouteButton.layer.masksToBounds = true;
    [self addSubview:self.viewRouteButton];
    
    self.deviceMapButton = [[UIButton alloc]initWithFrame:CGRectMake(30+(SCREEN_WIDTH - 45)/2, 55, (SCREEN_WIDTH - 45)/2, 33)];
    self.deviceMapButton.backgroundColor = XY_COLOR(241,245,248);
    [self.deviceMapButton setTitleColor:LIGHT_TEXT_COLOR forState:UIControlStateNormal];
    [self.deviceMapButton setTitle:@"本机地图" forState:UIControlStateNormal];
    self.deviceMapButton.layer.cornerRadius = 3;
    self.deviceMapButton.layer.borderWidth = LINE_HEIGHT;
    self.deviceMapButton.layer.borderColor = XY_COLOR(170,178,196).CGColor;
    self.deviceMapButton.layer.masksToBounds = true;
    self.deviceMapButton.titleLabel.font =  SIMPLE_TEXT_FONT;
    [self addSubview:self.deviceMapButton];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
