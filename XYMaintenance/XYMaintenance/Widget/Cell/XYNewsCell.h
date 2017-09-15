//
//  XYNewsCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAdminDto.h"

@interface XYNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *titleBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *topIconView;

+ (NSString*)defaultReuseId;
- (void)setData:(XYNewsDto*)data;

@end
