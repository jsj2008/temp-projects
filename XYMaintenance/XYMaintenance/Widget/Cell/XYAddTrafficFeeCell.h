//
//  XYAddTrafficFeeCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"



@interface XYAddTrafficFeeCell :SWTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *feeTextField;
@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UIButton *endBtn;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;
@property (weak, nonatomic) IBOutlet UILabel *endLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeIdLabel;

+(CGFloat)defaultHeight;
+(NSString*)defaultReuseId;



@end
