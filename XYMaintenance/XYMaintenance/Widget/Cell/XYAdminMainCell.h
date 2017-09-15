//
//  XYAdminMainCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAdminMainCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *xyImageView;
@property (weak, nonatomic) IBOutlet UILabel *xyTitleView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *redSpotView;

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;
- (void)configCell:(BOOL)isRank;
- (void)setRankNumber:(NSInteger)rank;
@end
