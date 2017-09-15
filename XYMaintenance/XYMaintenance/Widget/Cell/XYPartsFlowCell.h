//
//  XYPartsFlowCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/11/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPartDto.h"

@interface XYPartsFlowCell : UITableViewCell

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;

- (void)setData:(XYPartsLogDto*)data;

@end
