//
//  XYCompleteOrderPlatformFeeCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAllTypeOrderDto.h"
@interface XYCompleteOrderPlatformFeeCell : UITableViewCell
+ (NSString*)defaultIdentifier;
+ (CGFloat)getHeight;
@property (strong, nonatomic) XYAllTypeOrderDto *platformFeeDto;
@property (nonatomic,copy) void (^selectBlock)(NSInteger rowNo);
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,assign) NSInteger rowNo;
@end
