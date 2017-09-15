//
//  XYBonusBaseCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBonusDto.h"
#import "XYPromotionDto.h"

@interface XYBonusBaseCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *totalBonusButton;
@property (weak, nonatomic) IBOutlet UIButton *todayBonusButton;
@property (weak, nonatomic) IBOutlet UIButton *monthBonusButton;

+ (CGFloat)getHeight;
+ (NSString*)defaultIdentifier;
- (void)setBonusAmountData:(XYBonusDto*)data;
- (void)setBonusCountData:(XYPromotionBonusDto*)data;
@end
