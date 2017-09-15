//
//  XYPartApplyLogCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/3/22.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPartDto.h"
@interface XYPartApplyLogCell : UITableViewCell

+ (NSString*)defaultReuseId;

+ (CGFloat)defaultHeight;

- (void)setData:(XYPartsApplyLogDto*)data;

@end
