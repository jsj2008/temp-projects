//
//  XYRecycleDeviceViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
//
@protocol XYRecycleDeviceDelegate <NSObject>
- (void)onDeviceSelected:(XYRecycleDeviceDto*)device;
@end

@interface XYRecycleDeviceViewController : XYBaseViewController
@property(assign,nonatomic) id<XYRecycleDeviceDelegate> delegate;
@end
