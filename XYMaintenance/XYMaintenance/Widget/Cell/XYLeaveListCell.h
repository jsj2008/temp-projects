//
//  XYLeaveListCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAttendanceDto.h"

@interface XYLeaveListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *actionButton;

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;
+ (CGFloat)foldedHeight;

- (void)setLeaveData:(XYLeaveDto*)data;
- (void)setFolded:(BOOL)folded;

@end
