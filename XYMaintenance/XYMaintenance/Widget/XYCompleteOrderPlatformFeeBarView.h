//
//  XYCompleteOrderPlatformFeeBarView.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYCompleteOrderPlatformFeeBarView : UIView
@property (nonatomic,copy) void (^submitFeeBlock)();
@property (nonatomic, strong) NSArray *dataArr;
@end
