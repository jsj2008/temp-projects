//
//  XYPlatformFeeCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/5.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPlatformFeeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStatusLabel;
+(NSString*)defaultReuseId;
@end
