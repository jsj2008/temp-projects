//
//  XYPartCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYPartCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYPartCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *partIdLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;

@end

@implementation XYPartCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellAccessoryNone;
    self.deviderHeight.constant= LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)defaultHeight{
    return 80;
}

+ (NSString*)defaultReuseId{
    return @"XYPartCell";
}

- (void)setListData:(XYPartDto*)data{
    if (!data) {
        return;
    }
    self.nameLabel.text = XY_NOTNULL( data.name,@"");
    self.usedCountLabel.text = [NSString stringWithFormat:@"%ld个",(long)data.num];
    self.usedCountLabel.textColor = THEME_COLOR;
    self.partIdLabel.text = XY_NOTNULL(data.serial_number,@"");
}

- (void)setClaimDetailData: (XYPartDto*)data{
   
    if (!data) {
        return;
    }
    
    self.nameLabel.text = XY_NOTNULL( data.name,@"");
    self.usedCountLabel.textColor = THEME_COLOR;
    self.usedCountLabel.text = [NSString stringWithFormat:@"X%@",@(data.num)];
    self.partIdLabel.text = XY_NOTNULL(data.serial_number,@"");
}

@end
