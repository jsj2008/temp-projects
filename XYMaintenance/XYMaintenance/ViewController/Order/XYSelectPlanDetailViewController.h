//
//  XYSelectPlanDetailViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYSelectPlanDetailDelegate <NSObject>
- (void)onPlanDetailSelected:(NSString*)planId descrption:(NSString*)repairType;
@end

@interface XYSelectPlanDetailViewController : XYBaseViewController

- (instancetype)initWithDelegate:(id<XYSelectPlanDetailDelegate>)delegate
                          device:(NSString*)deviceId
                           brand:(NSString*)brandId
                           fault:(NSString*)faultId
                           color:(NSString*)colorId
                       orderType:(XYOrderType)orderStatus;



@end
