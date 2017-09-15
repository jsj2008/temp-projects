//
//  XYOrderCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDTOContainer.h"

@interface XYOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *statusButton;


+(CGFloat)defaultHeight;

+(NSString*)defaultReuseId;

-(void)setData:(XYOrderBase*)data;

@end
