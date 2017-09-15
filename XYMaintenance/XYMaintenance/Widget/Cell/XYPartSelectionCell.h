//
//  XYPartSelectionCell.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/4.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPartDto.h"

@interface XYPartSelectionCell : UITableViewCell

+ (CGFloat)defaultHeight;
+ (NSString*)defaultReuseId;

- (void)setData:(XYPartsSelectionDto*)data;
@property (nonatomic,copy) void (^numChangeBlock)(NSInteger num);
@end
