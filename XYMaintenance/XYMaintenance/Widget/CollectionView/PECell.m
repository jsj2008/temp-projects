//
//  PECell.m
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "PECell.h"
#import "XYConfig.h"

@interface PECell()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@end

@implementation PECell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.xyTitleLabel.textColor = LIGHT_TEXT_COLOR;
    self.bgView.layer.borderWidth = LINE_HEIGHT;
    self.bgView.layer.cornerRadius = LINE_HEIGHT*5;
    self.bgView.layer.borderColor = LIGHT_TEXT_COLOR.CGColor;
}

+ (NSString*)defaultReuseId{
    return @"PECell";
}

- (void)setItemSelected:(BOOL)selected{
    self.xyTitleLabel.textColor = selected?THEME_COLOR:LIGHT_TEXT_COLOR;
    self.bgView.layer.borderColor = selected?THEME_COLOR.CGColor:LIGHT_TEXT_COLOR.CGColor;
}

@end
