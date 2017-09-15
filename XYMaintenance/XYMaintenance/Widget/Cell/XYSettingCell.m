//
//  XYSettingCell.m
//  XYHiRepairs
//
//  Created by DamocsYang on 15/10/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYSettingCell.h"

static NSString *const XYSettingCellIdentifier = @"XYSettingCellIdentifier";

@interface XYSettingCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *badageHeight;
@end

@implementation XYSettingCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
        self.titleTextLabel.font = [UIFont systemFontOfSize:15];
        // 红点通知视图
        self.badgeView.textColor = [UIColor whiteColor];
        self.badgeView.backgroundColor = [UIColor redColor];
        self.badgeView.layer.masksToBounds = true;
        self.badgeView.layer.cornerRadius = self.badageHeight.constant/2;
        [self setBadgeNumber:0 hideNumber:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

+ (NSString*)defaultReuseIdentifier{
    return XYSettingCellIdentifier;
}

+ (UINib*)defaultNib{
    return [UINib nibWithNibName:@"XYSettingCell" bundle:nil];
}

- (void)setBadgeNumber:(NSInteger)count hideNumber:(BOOL)shouldHideNumber{
    
    if (count<=0) {
        self.badgeView.hidden=true;
        return;
    }
    self.badgeView.hidden = false;
    self.badgeView.text = shouldHideNumber?@" ":[NSString stringWithFormat:@"%ld",(long)count];
    self.badgeView.textColor = shouldHideNumber?self.badgeView.backgroundColor:[UIColor whiteColor];

}


@end
