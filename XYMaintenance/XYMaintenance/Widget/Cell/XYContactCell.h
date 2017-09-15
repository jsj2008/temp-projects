//
//  XYContactCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYContactCell : UITableViewCell

+(CGFloat)defaultHeight;

+(NSString*)defaultReuseId;

-(void)setData:(XYContactDto*)data;

@end
