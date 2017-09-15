//
//  XYAdminMainCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAdminMainCell.h"
#import "XYConfig.h"

@interface XYAdminMainCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel1;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel2;
@end

@implementation XYAdminMainCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.numberLabel.layer.cornerRadius = 9.0f;
    self.numberLabel.layer.masksToBounds = true;
    self.numberLabel.textColor = THEME_COLOR;
    self.redSpotView.layer.cornerRadius = 4.0f;
    self.redSpotView.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYAdminMainCell";
}

+ (CGFloat)defaultHeight{
    return 55;
}

- (void)configCell:(BOOL)isRank{
    if (isRank) {
        self.xyImageView.image = [UIImage imageNamed:@"home_rank"];
        self.xyTitleView.text = @"排行榜";
        self.redSpotView.hidden = true;
    }else{
        self.xyImageView.image = [UIImage imageNamed:@"home_attendance"];
        self.xyTitleView.text = @"考勤管理";
    }
    self.numberLabel.hidden = self.rankLabel1.hidden = self.rankLabel2.hidden = !isRank;
}

- (void)setRankNumber:(NSInteger)rank{
    self.numberLabel.text = [NSString stringWithFormat:@"%@",@(rank)];
}

@end
