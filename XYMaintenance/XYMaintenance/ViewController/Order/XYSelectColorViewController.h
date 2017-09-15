//
//  XYSelectColorViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYAddOrderViewModel.h"

@protocol XYSelectColorDelegate <NSObject>
- (void)onColorSelected:(NSString*)colorName colorId:(NSString*)colorId planId:(NSString*)planId planName:(NSString*)planName;
@end

@interface XYSelectColorViewController : XYBaseViewController

- (instancetype)initWithDevice:(NSString*)deviceId
                         brand:(NSString*)brandId
                         fault:(NSString*)faultId
                           bid:(XYBrandType)bid
                      delegate:(id<XYSelectColorDelegate>)delegate
                  allowedColor:(NSString*)allowedColorId//指定展示的color
                     orderType:(XYOrderType)orderStatus;


@end
