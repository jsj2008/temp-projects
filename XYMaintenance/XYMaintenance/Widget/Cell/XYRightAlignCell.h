//
//  XYRightAlignCell.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/13.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYRightAlignCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *xyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *xyContentLabel;

+ (NSString*)defaultReuseId;
@end
