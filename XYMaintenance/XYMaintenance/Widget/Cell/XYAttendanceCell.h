//
//  XYAttendanceCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAttendanceDto.h"

@interface XYAttendanceCell : UITableViewCell
+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;
- (void)setAttendanceData:(XYAttendanceDto*)data;
@end
