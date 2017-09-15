//
//  XYNewsCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYNewsCell.h"
#import "XYConfig.h"

@implementation XYNewsCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYNewsCell";
}

- (void)setData:(XYNewsDto*)data{
    
    self.topIconView.hidden = !data.is_top;
    self.titleBackgroundView.backgroundColor = data.is_top? XY_HEX(0xfffaf4):[UIColor whiteColor];
    self.dateLabel.text = XY_NOTNULL(data.dateString, @"0000/00/00/00/00");
    
    NSMutableAttributedString *attrTitle = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  ",XY_NOTNULL(data.title, @"公告标题")]];
    NSTextAttachment *attach = [[NSTextAttachment alloc] init];
    attach.image = [UIImage imageNamed:(data.bid == XYBrandTypeMeizu)?@"news_sf":@"news_hi"];
    attach.bounds = CGRectMake(0, -3, 16, 16);
    NSAttributedString *attrIcon = [NSAttributedString attributedStringWithAttachment:attach];
    [attrTitle appendAttributedString:attrIcon];
    self.contentLabel.attributedText = attrTitle;
}

@end
