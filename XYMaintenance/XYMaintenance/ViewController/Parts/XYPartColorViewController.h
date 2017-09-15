//
//  XYPartColorViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYPartDto.h"
@protocol XYPartColorDelegate <NSObject>
- (void)onPartsSelected:(XYPartsSelectionDto *)partsSelection;
@end

@interface XYPartColorViewController : XYBaseViewController
- (instancetype)initWithDevice:(NSString*)deviceId
                         brand:(NSString*)brandId
                         fault:(NSString*)faultId
                           bid:(XYBrandType)bid
                      delegate:(id<XYPartColorDelegate>)delegate;

@end
