//
//  XYTrafficPOICell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/9.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficPOICell.h"
#import "XYConfig.h"

@interface XYTrafficPOICell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *devider2Width;




@end

@implementation XYTrafficPOICell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.devider1Width.constant=LINE_HEIGHT;
    self.devider2Width.constant=LINE_HEIGHT;

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
    return @"XYTrafficPOICell";
}



@end
