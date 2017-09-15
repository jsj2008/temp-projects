//
//  XYPartDeviceViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYPartDto.h"
@protocol XYPartDeviceDelegate <NSObject>
- (void)onPartsSelected:(XYPartsSelectionDto *)partsSelection;
@end

@interface XYPartDeviceViewController : XYBaseViewController
//data
@property(assign,nonatomic) id<XYPartDeviceDelegate> delegate;
@end
