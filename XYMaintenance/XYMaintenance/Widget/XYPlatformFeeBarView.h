//
//  XYPlatformFeeBarView.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/5.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPlatformFeeBarView : UIView
@property (nonatomic,copy) void (^submitFeeBlock)();
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@end
