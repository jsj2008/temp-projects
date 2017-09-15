//
//  XYCityAreaCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDLabelView.h"

@interface XYCityAreaCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cityField;
@property (weak, nonatomic) IBOutlet UITextField *areaField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;

+ (CGFloat)defaultHeight;
+ (NSString*)defaultReuseId;

- (void)setCity:(NSString*)city area:(NSString*)area;
@end
