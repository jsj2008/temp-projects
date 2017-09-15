//
//  XYJustifiedCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDLabelView.h"

@interface XYJustifiedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UITextField *xyTextField;
@property (weak, nonatomic) IBOutlet UIImageView *xyAccessoryMark;

+ (CGFloat)defaultHeight;
+ (NSString*)defaultReuseId;

@end
