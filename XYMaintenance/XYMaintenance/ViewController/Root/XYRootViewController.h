//
//  XYRootViewController.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYPushDto.h"

/**
 *  根视图控制器 管理登录和主标签栏控制器
 */
@interface XYRootViewController : XYBaseViewController

@property(nonatomic,assign)XYPushNotificationType preNotificationType;

- (void)jumpToPageByType:(XYPushNotificationType)type;
- (void)showMarkByType:(XYPushNotificationType)type;



//展示登录页面
- (void)goToLogin;
//展示订单列表
- (void)goToOrderList;
////展示公告
//- (void)goToNewsList;
////跳转地图页面
//- (void)goToOrderMap;
////在订单tab上显示红点
//- (void)showRedPointOnOrderList;
////在地图tab上显示红点
//- (void)showRedPointOnMap;
////在公告按钮上显示红点
//- (void)showRedPointOnNews;
@end
