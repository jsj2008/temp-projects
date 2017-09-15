//
//  BaseViewController.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYConfig.h"
#import "XYStringUtil.h"
#import "XYBaseTableView.h"
#import "XYWidgetUtil.h"
#import "XYStrings.h"
#import "DTO.h"
#import "API.h"
#import "Masonry.h"
#import "UITableViewCell+XYTableViewRegister.h"
#import "XYAlertTool.h"


@interface XYBaseViewController : UIViewController

/**
 *  子类实现基础方法
 */
- (void)initializeModelBinding;
- (void)registerForNotifications;
- (void)initializeData;
- (void)initializeUIElements;


/**
 *  页面提示
 */
-(void)showLoadingMask;
-(void)hideLoadingMask;
-(void)showToast:(NSString*)toast;

/**
 *  页面返回功能相关
 */
-(void)shouldShowBackButton:(BOOL)isShown;
-(void)switchToGestureBackMode:(BOOL)canSwipeBack;
-(void)goBack;

@end
