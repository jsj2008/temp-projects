//
//  XYTrafficFeeCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficFeeCell.h"

@interface XYTrafficFeeCell ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@end

@implementation XYTrafficFeeCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)defaultHeight
{
    return 45;
}

+(NSString*)defaultReuseId
{
   return @"XYTrafficFeeCell";
}

-(void)setData:(XYMonthlyFeeDto*)data
{
    if (data == nil) {
        return;
    }
    
    self.timeLabel.text = data.date;
    self.feeLabel.text = [NSString stringWithFormat:@"￥%@",data.money];
}

@end
