//
//  XYCommentView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

@interface XYCommentView : UIView
+(XYCommentView*)getCommentView;
-(void)setData:(XYPHPCommentDto*)data;
@end
