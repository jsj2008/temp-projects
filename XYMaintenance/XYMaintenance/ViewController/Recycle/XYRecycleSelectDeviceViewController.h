//
//  XYRecycleSelectDeviceViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/25.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYRecycleDeviceDelegate <NSObject>
- (void)onDeviceSelected:(XYRecycleDeviceDto*)device;
@end

@interface XYRecycleSelectDeviceViewController : XYBaseViewController
@property(assign,nonatomic) id<XYRecycleDeviceDelegate> delegate;
@end
