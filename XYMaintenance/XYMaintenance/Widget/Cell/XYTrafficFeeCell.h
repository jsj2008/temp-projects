//
//  XYTrafficFeeCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYTrafficFeeCell : UITableViewCell

+(CGFloat)defaultHeight;
+(NSString*)defaultReuseId;
-(void)setData:(XYMonthlyFeeDto*)data;
@end
