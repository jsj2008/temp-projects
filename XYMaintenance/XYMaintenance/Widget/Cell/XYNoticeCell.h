//
//  XYNoticeCell.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DTO.h"

@interface XYNoticeCell : SWTableViewCell

+(CGFloat)defaultHeight;

+(NSString*)defaultReuseId;

-(void)setData:(XYNoticeDto*)data;

@end
