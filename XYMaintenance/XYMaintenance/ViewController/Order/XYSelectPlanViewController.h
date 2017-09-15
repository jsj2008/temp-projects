//
//  XYSelectPlanViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYAddOrderViewModel.h"

@protocol XYSelectRepairingPlanDelegate <NSObject>
- (void)onRepairingPlanSelected:(NSString*)planId color:(NSString*)colorName colorId:(NSString*)colorId repairType:(NSString*)planDescription;
@end

@interface XYSelectPlanViewController : XYBaseViewController
@property(assign,nonatomic) id<XYSelectRepairingPlanDelegate> delegate;

- (id)initWithDevice:(NSString*)deviceId
               brand:(NSString*)brandId
                 bid:(XYBrandType)bid
        allowedColor:(NSString*)allowedColor //限制可选颜色id（魅族订单修改维修方案时，不允许选择与原订单颜色不符的方案）
       editOrderType:(XYOrderType)orderStatus;//是否需要售后订单对应的故障大类列表（售后订单修改维修方案时，不允许选择“调试”以外的大类选项）


@end
