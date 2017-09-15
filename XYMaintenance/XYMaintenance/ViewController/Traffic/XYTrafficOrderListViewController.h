//
//  XYTrafficOrderListViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"


@protocol XYTrafficLocationDelegate <NSObject>

-(void)onLocationStrSelected:(NSString*)locString routeIndex:(NSInteger)section startOrEnd:(BOOL)isStart;

@end

@interface XYTrafficOrderListViewController : XYBaseViewController

@property(assign,nonatomic)id<XYTrafficLocationDelegate>delegate;
@property(assign,nonatomic)NSInteger routeId;
@property(assign,nonatomic)BOOL isStartLoc;

@property(strong,nonatomic)NSString* date;

@end
