//
//  XYCompleteOrderCommonHeaderCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/11.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableViewCell.h"
@interface XYCompleteOrderCommonHeaderCell : SKSTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
+ (NSString*)defaultReuseId;
@property (assign, nonatomic) BOOL isFirst;
@end
