//
//  XYPartFaultViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYPartDto.h"
@protocol XYPartFaultDelegate <NSObject>
- (void)onPartsSelected:(XYPartsSelectionDto *)partsSelection;
@end

@interface XYPartFaultViewController : XYBaseViewController

- (id)initWithDevice:(NSString*)deviceId
               brand:(NSString*)brandId
                 bid:(XYBrandType)bid
            delegate:(id<XYPartFaultDelegate>)delegate;
@end
