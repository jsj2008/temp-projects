//
//  XYTopNewsCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/3.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYTopNewsCell.h"
#import "XYConfig.h"

@implementation XYTopNewsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.topLabel.backgroundColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYTopNewsCell";
}

+ (CGFloat)defaultHeight{
    return 40;
}

- (void)setContent:(NSString*)title{
    self.contentLabel.text = XY_NOTNULL(title, @"置顶公告");
}

@end
