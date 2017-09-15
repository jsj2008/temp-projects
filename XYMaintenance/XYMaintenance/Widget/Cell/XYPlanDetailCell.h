//
//  XYPlanDetailCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYPlanDetailCell : UITableViewCell

+ (NSString*)defaultReuseId;
+ (CGFloat)getCellHeightOfRepairType:(NSString*)str;

- (void)setData:(XYPlanDto*)data;

@end
