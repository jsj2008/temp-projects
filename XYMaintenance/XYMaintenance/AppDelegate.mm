//
//  AppDelegate.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "AppDelegate.h"
#import "HttpCache.h"
#import "XYConfig.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "JPUSHService.h"
#import "XYPushDto.h"
#import "XYRootViewController.h"
#import "XYAPIService.h"
#import "XYAPPSingleton.h"
#import "XYOrderListManager.h"
#import "XYAlertTool.h"
#import "XYLocationManagerWithTimer.h"
#import "XYLocationManagerBackground.h"
#import <UMMobClick/MobClick.h>
#import "Harpy.h"
#import "SDTrackTool.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif


@interface AppDelegate ()<WXApiDelegate, JPUSHRegisterDelegate>
@property (assign, nonatomic) NSInteger currentBadge;
@end

@implementation AppDelegate

#pragma mark - on app launched

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    /*
    马甲：1.target-ICON  ，target-displayname ，target-bundleid
     2.appstore后台-推广页, appstore后台-bundleid, appstore后台-app名称， appstore后台-app图标，appstore后台-app描述
    3.代码
     根据HIVEST来判断，a.加载不同的key 
   
     */
#ifdef HIVEST
    NSLog(@"HIVEST");
#endif
    /**
     *  注册远程通知
     */
    [self registerNotificationOfApplication:application withOptions:launchOptions];
    
    /**
     *  注册第三方sdk
     */
    [self registerSDKs];
    
    /**
     *  设置UI通用属性
     */
    [self setUIAttributes];
    
    /**
     *  坐标上报功能相关
     */
    [self doLocationSettings:launchOptions];
    
    /**
     *  处理从通知打开app的携带消息
     */
    XYPushNotificationType notificationType = [self processNotificationOnEnter:launchOptions];
    
    /**
     *  启动页面
     */
    [self goToRootView:notificationType];

    return YES;
}


- (void)registerSDKs{
    /**
     *  高德地图
     */
    [AMapServices sharedServices].apiKey = GAODE_KEY;

    //微信支付
    [WXApi registerApp:WCPAY_ID withDescription:@"HiEngineer"];
    
    //友盟
    [SDTrackTool configure];

    //JSPatch
    [JSPatch startWithAppKey:JSPATCH_KEY];
//脚本
#ifdef DEBUG
    [JSPatch setupDevelopment];
#endif
    [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDfCqH/rGusfWtVaXuwhMmuavdM\nZ+VUluz3z8WOr37QFbfAH3HlJNaya540JH6V5UOEq3TTouLqqWCwIhKjJ5dJhlPh\n3P1t0nPeVxpv/yIqCIRuswGMkbYf4xdoopDp7GaoFKsSm+K8dYMwVy43EkIHU5uN\nyQb8BnvCaeG6UepP+wIDAQAB\n-----END PUBLIC KEY-----"];
    [JSPatch sync];
    //注释上面所有jspatch，测试bundle
    //     [JSPatch testScriptInBundle];
//在线参数
//    [JSPatch updateConfigWithAppKey:JSPATCH_KEY];
    [JSPatch updateConfigWithAppKey:JSPATCH_KEY withInterval:10];
//    [JSPatch setupUpdatedConfigCallback:^(NSDictionary *configs, NSError *error) {
//        NSLog(@"configs-%@, error-%@", configs, error);
//    }];
    NSDictionary *para = [JSPatch getConfigParams];
    NSLog(@"para-%@", para);
    NSString *locationInterval = [JSPatch getConfigParam:@"locationInterval"];
    NSLog(@"locationInterval-%@", locationInterval);
}
   

- (void)setUIAttributes{
    
    UIImage *navigationPortraitBackground = [XYWidgetUtil imageWithColor:THEME_COLOR];
    [[UINavigationBar appearance] setBackgroundImage:navigationPortraitBackground forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc]init]];
    
    [[UITabBar appearance]setBackgroundImage:[XYWidgetUtil imageWithColor:XY_COLOR(246,248,251)]];
    UIImage* tabBarShadow = [XYWidgetUtil imageWithColor:XY_COLOR(207,214,224)];
    [[UITabBar appearance] setShadowImage:tabBarShadow];
    
    [[UINavigationBar appearance] setTitleTextAttributes:
    [NSDictionary dictionaryWithObjectsAndKeys:
    WHITE_COLOR, NSForegroundColorAttributeName,
    [UIFont boldSystemFontOfSize:18.0], NSFontAttributeName, nil]];

    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11.0f], NSFontAttributeName,LIGHT_TEXT_COLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:                                                         [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:11.0f], NSFontAttributeName,THEME_COLOR,NSForegroundColorAttributeName, nil]forState:UIControlStateSelected];

    NSMutableDictionary *attr = [[NSMutableDictionary alloc] init];
    [attr setValue:WHITE_COLOR forKey:NSForegroundColorAttributeName];
    [[UIBarButtonItem appearance] setTitleTextAttributes:attr forState:UIControlStateNormal];
}


/**
 *  禁止手机横屏
 */
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)goToRootView:(XYPushNotificationType)extraType{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _rootViewController = [[XYRootViewController alloc]init];
    _rootViewController.preNotificationType = extraType;
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:_rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
}


- (void)setupSwitchConfiguration {
    [[XYAPIService shareInstance] getSwitchConfiguration:^(XYConfigDto *config) {
        [XYConfigParamUtil save:config];
    } errorString:^(NSString *err) {}];
}

- (void)showLoginView{
    [self.rootViewController goToLogin];
}

#pragma mark - notification

/**
 *  注册远程通知
 */
- (void)registerNotificationOfApplication:(UIApplication *)application withOptions:(NSDictionary *)options{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        entity.categories = [NSSet setWithObjects:[XYPushDto createiOS10OrderCategory], nil, nil];
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:entity.categories];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
#endif
    } else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        UIMutableUserNotificationCategory* orderCategory = [XYPushDto createOrderCategory];
        //添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:[NSSet setWithObjects:orderCategory, nil, nil]];
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:[NSSet setWithObjects:orderCategory,nil,nil]];
        [application registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    
#warning xyappstore:true test:false
    [JPUSHService setupWithOption:options appKey:JPUSH_APPKEY
                          channel:@"HiEngineer"
                 apsForProduction:true
            advertisingIdentifier:nil];
}

- (void) application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken
{
    [JPUSHService registerDeviceToken:pToken];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    TTDEBUGLOG(@"receive notification fetchCompletionHandler with userInfo: %@ state:%@", userInfo,@(application.applicationState));
    XYPushNotificationType type = [XYPushDto getTypeByUserInfo:userInfo];
    TTDEBUGLOG(@"收到推送type:%@",@(type));
    //两种情况：前台显示红点 和 后台跳页面
    if (application.applicationState == UIApplicationStateActive){
        //在前台，不需要角标
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.currentBadge = 0;
        //本地推声音
        [XYPushDto playSoundByName:[XYPushDto getSoundFileByType:type]];
        [self.rootViewController showMarkByType:type];
    }else{
        //后台app显示数字角标
        NSInteger badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
        self.currentBadge += MAX(badge, 1);
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.currentBadge;
        [self.rootViewController jumpToPageByType:type];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    TTDEBUGLOG(@"register failed due to error: %@", error);
}

- (XYPushNotificationType)processNotificationOnEnter:(NSDictionary*)options{
    //接收远程通知参数
    NSDictionary *userInfo = [options objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (userInfo){
        XYPushNotificationType type = [XYPushDto getTypeByUserInfo:userInfo];
        TTDEBUGLOG(@"从消息启动 推送type:%@",@(type));
        return type;
    }
    return XYPushNotificationTypeUnknown;
}

- (BOOL)isAllowedNotification{
    //iOS8 check if user allow notification
    if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if(UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    }
    return NO;
}

- (void)forceNotificationServiceOpen{
    if ([[XYAPPSingleton sharedInstance] isFirstLoginToday]) {
        return;
    }
    if (![self isAllowedNotification]) {
        [XYAlertTool showAllowNotifcationAlert];
    }
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- iOS10推送
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        TTDEBUGLOG(@"iOS10 前台 receive notification fetchCompletionHandler with userInfo: %@", userInfo);
        XYPushNotificationType type = [XYPushDto getTypeByUserInfo:userInfo];
        TTDEBUGLOG(@"收到推送type:%@",@(type));
        //在前台，不需要角标
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.currentBadge = 0;
//        //本地推声音
//        [XYPushDto playSoundByName:[XYPushDto getSoundFileByType:type]];
        [self.rootViewController showMarkByType:type];
    }else {
        // 判断为本地通知
        //        TTDEBUGLOG(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        TTDEBUGLOG(@"iOS10 后台 receive notification fetchCompletionHandler with userInfo: %@", userInfo);
        XYPushNotificationType type = [XYPushDto getTypeByUserInfo:userInfo];
        TTDEBUGLOG(@"收到推送type:%@",@(type));
        //后台app显示数字角标
        NSInteger badge = [[[userInfo objectForKey:@"aps"] objectForKey:@"badge"] integerValue];
        self.currentBadge += MAX(badge, 1);
        [UIApplication sharedApplication].applicationIconBadgeNumber = self.currentBadge;
        [self.rootViewController jumpToPageByType:type];
        
        //快捷接单
        NSString *categoryIdentifier = response.notification.request.content.categoryIdentifier;
        if ([categoryIdentifier isEqualToString:XYNotificationActionCategoryAcceptOrder]) {
            //根据actionIdentifier区分Action
            if ([response.actionIdentifier isEqualToString:XYNotificationActionActionAcceptOrder]) {
                NSString *orderId = [response.notification.request.content.userInfo objectForKey:@"order_id"];
                XYBrandType bid = (XYBrandType)[[response.notification.request.content.userInfo objectForKey:@"bid"] integerValue];
                TTDEBUGLOG(@"快捷接单1：%@,%@",orderId,@(bid));
                [XYPushDto acceptOrder:orderId bid:bid withCompletionHandler:completionHandler];
            }
        }
    }
    completionHandler();  // 系统要求执行这个方法
}
#endif

#pragma mark- iOS10以下推送
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//处理通知action iOS8 iOS9
- (void) application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler{
    if([identifier isEqualToString:XYNotificationActionActionAcceptOrder]){
        NSString* orderId = [userInfo objectForKey:@"order_id"];//todo
        XYBrandType bid = (XYBrandType)[[userInfo objectForKey:@"bid"] integerValue];//todo
        TTDEBUGLOG(@"快捷接单3：%@,%@",orderId,@(bid));
        [XYPushDto acceptOrder:orderId bid:bid withCompletionHandler:completionHandler];
    }
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier
forLocalNotification:(UILocalNotification *)notification
  completionHandler:(void (^)())completionHandler {
    if (completionHandler)
        completionHandler();
}

#endif

#pragma mark - location

- (void)doLocationSettings:(NSDictionary*)lauchOptions{
     if ([lauchOptions objectForKey:UIApplicationLaunchOptionsLocationKey]) {
         if (IS_IOS_8_LATER) {
                [[XYLocationManagerBackground sharedManager] requestAlwaysAuthorization];
         }
         if (IS_IOS_9_LATER){
                 [[XYLocationManagerBackground sharedManager] setAllowsBackgroundLocationUpdates:YES];
         }
     }
    [[XYLocationManagerBackground sharedManager] startMonitoringSignificantLocationChanges];
    [[XYLocationManagerWithTimer sharedManager] updateLocation];
}

/*
#pragma mark - location

-(void)updateLocation{
    [self.locationTracker updateLocationToServer];
}

-(void)doLocationSettings:(NSDictionary*)option
{
//    if ([option objectForKey:UIApplicationLaunchOptionsLocationKey]) {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
//        [[MMLocationManager sharedManager] requestAlwaysAuthorization];
//#endif
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
//        [[MMLocationManager sharedManager] setAllowsBackgroundLocationUpdates:YES];
//#endif
//        [[MMLocationManager sharedManager] startMonitoringSignificantLocationChanges];
//    }
    
    if([[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusDenied || [[UIApplication sharedApplication] backgroundRefreshStatus] == UIBackgroundRefreshStatusRestricted){
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"后台刷新不可用"
                                          message:@"请前往“设置”->“通用”开启后台应用程序刷新，便于后台获取您的位置。"
                                         delegate:nil
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
        [alert show];
    }else{
        
        self.locationTracker = [[LocationTracker alloc]init];
        self.locationTracker.isBackground = ([option objectForKey:UIApplicationLaunchOptionsLocationKey]!=nil);
        [self.locationTracker startLocationTracking];
        
        NSTimeInterval time = 60.0 * XY_UPDATE_LOCATION_INTERVAL;
        
        NSString* locInterval = [CacheHelper getStringForKey:kLocationUploadInterval];
        if (![XYStringUtil isNullOrEmpty:locInterval]) {
            time = [locInterval doubleValue];
        }
        if (time < 60.0) {
            time = 60.0 * XY_UPDATE_LOCATION_INTERVAL;
        }

        self.locationUpdateTimer =
        [NSTimer scheduledTimerWithTimeInterval:time
                                         target:self
                                       selector:@selector(updateLocation)
                                       userInfo:nil
                                        repeats:YES];
        [self performSelector:@selector(updateLocation) withObject:nil afterDelay:20];
    }

}

*/

#pragma mark - life cycle others

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   // [BMKMapView willBackGround];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    self.currentBadge = 0;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
    /**
     *  回归前台时强制检测推送开启功能
     */
    //[self forceNotificationServiceOpen];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[Harpy sharedInstance] checkVersion];
    if ([XYConfigParamUtil xy_config].fastHotPatch) {
        [JSPatch updateConfigWithAppKey:JSPATCH_KEY withInterval:60*30];
        [JSPatch sync];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark - open url

//iOS9+
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            TTDEBUGLOG(@"%@",resultDic);
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//iOS9-
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    TTDEBUGLOG(@"%@",url.host);
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            TTDEBUGLOG(@"jumpBack = %@",resultDic);
        }];
    }else{
        [WXApi handleOpenURL:url delegate:self];
    }
    return YES;
}

//微信支付回调
- (void)onResp:(BaseResp*)resp{
     TTDEBUGLOG(@"jump back %@",resp);//WXSuccess
     if([resp isKindOfClass:[PayResp class]]){
        [[NSNotificationCenter defaultCenter] postNotificationName:XY_NOTIFICATION_WECHAT_SDK_PAID object:resp];
     }
}


@end
