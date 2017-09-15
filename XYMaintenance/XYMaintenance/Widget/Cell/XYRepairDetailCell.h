//
//  XYRepairDetailCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYRepairDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;
@end
