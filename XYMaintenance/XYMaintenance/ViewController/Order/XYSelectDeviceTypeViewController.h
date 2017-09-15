//
//  XYSelectDeviceTypeViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYInputCustomDeviceViewController.h"


@protocol XYSelectDeviceTypeDelegate <NSObject>

- (void)onDeviceSelected:(XYPHPDeviceDto*)device color:(NSString*)colorId newPlan:(NSString*)planId;

@end

@interface XYSelectDeviceTypeViewController : XYBaseViewController

@property(strong,nonatomic) XYInputCustomDeviceViewController* customController;

- (instancetype)initWithType:(XYOrderDeviceType)type
              allowCustomize:(BOOL)allowCustomDevice
                    delegate:(id<XYSelectDeviceTypeDelegate>)delegate
                  allowedBrand:(NSString*)brandId
                  allowedColor:(NSString*)colorId;

@end
