//
//  XYLeaveViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYLeaveViewDelegate <NSObject>
- (void)onLeaveApplicationSubmitted;
@end

@interface XYLeaveViewController : XYBaseViewController
@property(assign,nonatomic)id<XYLeaveViewDelegate> delegate;
@end
