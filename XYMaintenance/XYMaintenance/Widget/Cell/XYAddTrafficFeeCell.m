//
//  XYAddTrafficFeeCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYAddTrafficFeeCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYAddTrafficFeeCell ()//<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider2Height;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider3Height;
@end

@implementation XYAddTrafficFeeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.devider1Width.constant = LINE_HEIGHT;
    self.devider2Height.constant = LINE_HEIGHT;
    self.devider3Height.constant = LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+(CGFloat)defaultHeight
{
    return 136;
}

+(NSString*)defaultReuseId
{
  return @"XYAddTrafficFeeCell";
}

@end
