//
//  XYCompleteOrderCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DTO.h"

@interface XYCompleteOrderCell : SWTableViewCell

+ (CGFloat)getHeight;
+ (NSString*)defaultIdentifier;

- (void)setAllTypeOrderData:(XYAllTypeOrderDto*)data;

@end
