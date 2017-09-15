//
//  XYNoticeViewController.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/20.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYNoticeViewDelegate <NSObject>

-(void)onNoticeDeleted;//或者叫read

@end

@interface XYNoticeViewController : XYBaseViewController

@end
