//
//  XYContactCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYContactCell.h"
#import "UIImageView+YYWebImage.h"

@interface XYContactCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation XYContactCell

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
    return 60;
}

+(NSString*)defaultReuseId
{
   return @"XYContactCell";
}

-(void)setData:(XYContactDto*)data
{
    if (data == nil)
    {
        return;
    }
    
    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:data.avatarUrl] placeholder:[UIImage imageNamed:@"img_avatar"]];
    self.nameLabel.text = data.name;
    self.phoneLabel.text = data.phone;

}

@end
