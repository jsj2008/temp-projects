//
//  XYRouteCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/5.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRouteCell.h"
#import "XYConfig.h"

@interface XYRouteCell ()
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingLabel;

@end

@implementation XYRouteCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.indexLabel.textColor = THEME_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)defaultHeight
{
    return 63;
}

+(NSString*)defaultReuseId
{
    return @"XYRouteCell";
}

-(void)setData:(XYRouteBaseDto*)data index:(NSInteger)index
{
    if (data == nil)
    {
        return;
    }
    
    self.indexLabel.text = [NSString stringWithFormat:@"%02ld",(long)(index + 1)];
    self.titleLabel.text = data.title;
    self.distanceLabel.text = data.distance;
    self.timeLabel.text = data.time;
    self.walkingLabel.text = data.walkingDistance;
}

@end
