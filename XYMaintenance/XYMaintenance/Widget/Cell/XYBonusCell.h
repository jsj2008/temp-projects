//
//  XYBonusCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYBonusDto.h"
#import "XYPromotionDto.h"

@interface XYBonusCell : UITableViewCell

+ (CGFloat)getHeight;
+ (NSString*)defaultIdentifier;

- (void)setRepairBonusData:(XYBonusDetailDto*)data;
- (void)setPICCBonusData:(XYPICCBonusDto*)data;
- (void)setRecycleBonusData:(XYRecycleBonusDto*)data;
- (void)setPromotionBonusData:(XYPromotionBonusDetail*)data;
@end
