//
//  XYPartCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYPartCell : UITableViewCell

+ (CGFloat)defaultHeight;
+ (NSString*)defaultReuseId;

- (void)setListData:(XYPartDto*)data;

- (void)setClaimDetailData: (XYPartDto*)data;
@end
