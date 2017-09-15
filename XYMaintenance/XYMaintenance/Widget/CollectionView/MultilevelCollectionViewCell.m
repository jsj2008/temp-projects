//
//  MultilevelCollectionViewCell.m
//  XYHiRepairs
//
//  Created by lisd on 16/7/17.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "MultilevelCollectionViewCell.h"
#import "YYWebImage.h"
#import "XYStringUtil.h"

@interface MultilevelCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation MultilevelCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

+ (NSString*)defaultReuseId{
   return @"MultilevelCollectionViewCell";
}

- (void)setData:(XYRecycleDeviceDto*)dto{
    if (!dto) {
        return;
    }
    
   NSString* imgUrl = [XYStringUtil urlTohttps:dto.Pic];
   [self.imageView yy_setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"device_placeholder"]];
   self.titleLabel.text = dto.MouldName;
}

@end
