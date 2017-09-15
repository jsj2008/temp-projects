//
//  XYCancelReasonCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/4/11.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCancelReasonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *xyImageView;
@property (weak, nonatomic) IBOutlet UILabel *reasonLabel;

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;

- (void)setXYSelected:(BOOL)selected;

@end
