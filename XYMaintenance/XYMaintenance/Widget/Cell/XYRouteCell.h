//
//  XYRouteCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/5.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"



@interface XYRouteCell : UITableViewCell

+(CGFloat)defaultHeight;

+(NSString*)defaultReuseId;

-(void)setData:(XYRouteBaseDto*)data index:(NSInteger)index;

@end
