//
//  XYDailyOrderCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYDailyOrderCell.h"
#import "XYConfig.h"
#import "DTO.h"

@interface XYDailyOrderCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider2Width;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation XYDailyOrderCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.devider1Width.constant=LINE_HEIGHT;
    self.devider2Width.constant=LINE_HEIGHT;
    [self.selectButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)defaultHeight
{
    return 75;
}
+(NSString*)defaultReuseId
{
  return @"XYDailyOrderCell";
}

-(void)setData:(XYTrafficOrderLocDto*)data
{
    if (!data) {
        return;
    }
    
    self.orderIdLabel.text = data.Id;
    
    NSRange range = [data.FinishTime rangeOfString:@" "];
    
    if (range.length>0) {
        self.timeLabel.text = [data.FinishTime substringWithRange:NSMakeRange(range.location+1, 5)];
    }else{
        self.timeLabel.text = data.FinishTime;
    }
    self.addressLabel.text = data.address;
}

@end
