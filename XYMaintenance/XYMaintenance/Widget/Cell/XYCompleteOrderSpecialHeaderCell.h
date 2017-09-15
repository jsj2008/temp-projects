//
//  XYCompleteOrderSpecialHeaderCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"
@interface XYCompleteOrderSpecialHeaderCell : SKSTableViewCell
+ (NSString*)defaultReuseId;
@property (weak, nonatomic) IBOutlet UILabel *feeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (nonatomic,copy) void (^selectAllBlock)();
@property (assign, nonatomic) BOOL isSelectAll;
@end
