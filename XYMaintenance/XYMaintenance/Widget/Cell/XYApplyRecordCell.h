//
//  XYApplyRecordCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/3/10.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPartDto.h"
@interface XYApplyRecordCell : UITableViewCell
+ (NSString*)defaultReuseId;

@property (strong, nonatomic) XYPartsApplyLogDetailDto *partApplyLogDetailDto;

@end
