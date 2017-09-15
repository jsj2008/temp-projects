//
//  XYCancelOrderCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/4/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

@interface XYCancelOrderCell : UITableViewCell

- (void)setData:(XYCancelOrderDto*)data type:(BOOL)isPending;
+ (NSString*)defaultReuseId;
+ (CGFloat)getHeight;
@end
