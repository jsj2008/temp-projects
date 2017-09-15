//
//  XYDailyOrderCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYTrafficOrderLocDto;

@interface XYDailyOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

+(CGFloat)defaultHeight;
+(NSString*)defaultReuseId;

-(void)setData:(XYTrafficOrderLocDto*)data;

@end
