//
//  DYMonthlyCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "DYMonthlyCell.h"
#import "XYConfig.h"

@implementation DYMonthlyCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.monthLabel.layer.borderWidth = LINE_HEIGHT;
     self.monthLabel.layer.borderColor = THEME_COLOR.CGColor;
    self.monthLabel.backgroundColor = WHITE_COLOR;
}

+(NSString*)defaultReuseId
{
  return @"DYMonthlyCell";
}

-(void)setTitle:(NSString*)title
{
    if (!_monthLabel) {
        self.monthLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.contentView.bounds.size.width - 5, 30)];
        self.monthLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.monthLabel];
        self.monthLabel.layer.borderWidth = LINE_HEIGHT;
        self.monthLabel.layer.borderColor = THEME_COLOR.CGColor;
        self.monthLabel.layer.cornerRadius = LINE_HEIGHT*2;
        self.monthLabel.textColor = THEME_COLOR;
    }
    
    self.monthLabel.text = title;
    self.monthLabel.center = self.contentView.center;
}



@end
