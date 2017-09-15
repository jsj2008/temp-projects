//
//  XYNoticeCell.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYNoticeCell.h"
#import "XYConfig.h"


@interface XYNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation XYNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)defaultHeight
{
    return 62;
}

+(NSString*)defaultReuseId
{
    return @"XYNoticeCell";
}



-(void)setData:(XYNoticeDto*)data
{
    if (data==nil) {
        return;
    }
    
    self.titleLabel.text = data.title;
    self.detailLabel.text = data.detail;
    self.timeLabel.text = data.time;
}


@end
