//
//  XYOrderListCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "SWTableViewCell.h"
#import "DTO.h"

@interface XYOrderListCell : UITableViewCell

@property(retain,nonatomic,readonly)NSArray* rightButtonsArray;

+(CGFloat)defaultHeight;

+(CGFloat)foldedHeight;

+(NSString*)defaultReuseId;

-(void)setData:(XYOrderBase*)data;

@end
