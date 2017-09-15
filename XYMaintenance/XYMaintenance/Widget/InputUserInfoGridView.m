//
//  InputUserInfoGridView.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "InputUserInfoGridView.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@implementation InputUserInfoGridView

-(id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initializeUI];
    }
    return self;
}

-(void)initializeUI{
    self.backgroundColor = GRIDVIEW_COLOR;
    self.layer.cornerRadius = 2.0f;
    self.layer.borderWidth = LINE_HEIGHT;
    self.layer.borderColor = GRIDVIEW_BORDRE_COLOR.CGColor;
    self.layer.masksToBounds = true;
    
    UILabel* phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, self.bounds.size.height/2)];
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    phoneLabel.textColor = BLACK_COLOR;
    phoneLabel.text = @"联系方式";
    phoneLabel.font = LARGE_TEXT_FONT;
    phoneLabel.backgroundColor = GRIDVIEW_COLOR;
    [self addSubview:phoneLabel];
    
    UILabel* nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/2, 80, self.bounds.size.height/2)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = BLACK_COLOR;
    nameLabel.text = @"联系人";
    nameLabel.font = LARGE_TEXT_FONT;
    nameLabel.backgroundColor = GRIDVIEW_COLOR;
    [self addSubview:nameLabel];

    self.phoneField = [[UITextField alloc]initWithFrame:CGRectMake(90, 0, self.bounds.size.width - 90, self.bounds.size.height/2)];
    self.phoneField.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneField.font = LARGE_TEXT_FONT;
    self.phoneField.textColor = LIGHT_TEXT_COLOR;
    self.phoneField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:self.phoneField];

    self.nameField = [[UITextField alloc]initWithFrame:CGRectMake(90, self.bounds.size.height/2, self.bounds.size.width - 90, self.bounds.size.height/2)];
    self.nameField.font = LARGE_TEXT_FONT;
    self.nameField.textColor = LIGHT_TEXT_COLOR;
    self.nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self addSubview:self.nameField];
    
    UIView* verticalDevider = [[UIView alloc]initWithFrame:CGRectMake(80, 0, LINE_HEIGHT, self.bounds.size.height)];
    verticalDevider.backgroundColor = GRIDVIEW_DIVIDER_COLOR;
    [self addSubview:verticalDevider];
    
    UIView* horizontalDevider = [[UIView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height/2, self.bounds.size.width,LINE_HEIGHT)];
    horizontalDevider.backgroundColor = GRIDVIEW_DIVIDER_COLOR;
    [self addSubview:horizontalDevider];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
