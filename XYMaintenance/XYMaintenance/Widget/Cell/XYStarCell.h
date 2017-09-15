//
//  XYStarCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DYRateView.h"

@interface XYStarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet DYRateView *rateView;
+ (NSString*)defaultReuseId;
@property (nonatomic,copy) void (^clickStarButtonBlock)();
@end
