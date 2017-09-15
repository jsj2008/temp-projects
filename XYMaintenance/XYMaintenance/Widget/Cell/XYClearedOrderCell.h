//
//  XYClearedOrderCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYClearedOrderCell : UITableViewCell

+ (CGFloat)getHeight;
+ (NSString*)defaultIdentifier;

- (void)setAllTypeOrder:(XYAllTypeOrderDto*)data;

@end
