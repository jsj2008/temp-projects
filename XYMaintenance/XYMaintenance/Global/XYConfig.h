//
//  Config.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//  email:hiweixiudata@163.com password:hiweixiu123


#pragma mark - 配置
/************************************************************************/

#warning 注释开关 1.DEBUG 是否是要打印log的调试状态  2.SMARTFIX 是否是魅族的包
//#define __DEBUG  //1.上线包关闭打印log
//#define __SMARTFIX //2.是不是魅族的包？

/************************************************************************/

//版本配置项 （切换smartfix）
#ifdef __SMARTFIX
    #define THEME_COLOR XY_HEX(0x1787ff) //魅族主题色 原版0xff5000
    #define REVERSE_COLOR XY_HEX(0xff5000) //反转色 
    #define GAODE_KEY @"dd40c2c02011614279a5b9389d631e10" //魅族高德地图ios sdk key
    #define JPUSH_APPKEY @"9c2258f1b014c2cf1b48c8cf" //魅族极光推送
    #define JSPATCH_KEY @"52773b23a1c82afb"//魅族版jspatchkey
    #define UMENG_KEY @"587854658f4a9d5f7d0007ec"//原版友盟统计（无需求，仅作crah日志上报用）
    #define WCPAY_ID @""//!!！魅族的需要重新申请
    #define SERVICE_PHONE @"400-017-1010"//!!400-017-1010是hi维修的
#else
    #define THEME_COLOR XY_HEX(0xff5000) //原版0xff5000
    #define REVERSE_COLOR XY_HEX(0x258cff) //反转色
    #define GAODE_KEY @"619f3a138db3643cb52ab9aa8817ceda" // 原版高德地图ios sdk key
    #define JPUSH_APPKEY @"b357aa23f155751264af5e78" //原版极光推送
    #define JSPATCH_KEY @"6d87767a34432ab9"//原版jspatchkey
    #define UMENG_KEY @"587853f24544cb0675000315"//原版友盟统计（无需求，仅作crah日志上报用）
    #define WCPAY_ID @"wxc99901329b3d75b2"//微信支付
    #define SERVICE_PHONE @"400-017-1010"//服务电话
#endif

//控制台
#ifdef __DEBUG
    #define TTString [NSString stringWithFormat:@"%s", __FILE__].lastPathComponent
    #define TTDEBUGLOG(...) printf("%s 第%d行: %s\n\n",[TTString UTF8String] ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
    #define TTDEBUGLOG(...)
#endif

#ifdef DEBUG
    #define NSLog(...) NSLog(__VA_ARGS__)
    #define debugMethod() NSLog(@"%s", __func__)
#else
    #define NSLog(...)
    #define debugMethod()
#endif

/************************************************************************/

#pragma mark - 定义

#ifndef XYMaintenance_Config_h
#define XYMaintenance_Config_h
//设备
#define IS_IOS_8_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
#define IS_IOS_9_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0)
#define IS_IOS_10_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0)
//尺寸
#define LINE_HEIGHT 1.0/[UIScreen mainScreen].scale //线高
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height //屏幕完整高度
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width   //屏幕完整宽度
#define SCREEN_FRAME_HEIGHT [UIScreen mainScreen].applicationFrame.size.height //去掉状态栏的屏幕高度
#define NAVI_BAR_HEIGHT self.navigationController.navigationBar.frame.size.height

//字符串
#define XY_NOTNULL(str,dft) (str)?(str):(dft)
#define EnumToKey(type) [NSString stringWithFormat:@"%@",@(type)]

//颜色
#define XY_COLOR(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define XY_HEX(hexValue) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16)) / 255.0 green:((float)((hexValue & 0xFF00) >> 8)) / 255.0 blue:((float)(hexValue & 0xFF)) / 255.0 alpha:1.0]

#define BACKGROUND_COLOR XY_COLOR(247, 247, 247)
#define DEVIDE_LINE_COLOR XY_COLOR(217, 224, 233)
#define SWIPE_CELL_DARK_COLOR XY_COLOR(142,147,160)
#define YELLOW_COLOR XY_COLOR(255, 243, 203)
#define GREEN_COLOR XY_COLOR(5, 182, 16)
#define WHITE_COLOR [UIColor whiteColor]
#define TABLE_DEVIDER_COLOR XY_COLOR(210, 218, 228)

#define BLACK_COLOR XY_COLOR(51, 51, 51)
#define LIGHT_TEXT_COLOR XY_COLOR(102, 102, 102)
#define MOST_LIGHT_COLOR XY_COLOR(153, 153, 153)

#define GRIDVIEW_COLOR XY_COLOR(248, 250, 252)
#define GRIDVIEW_BORDRE_COLOR XY_COLOR(174,184,196)
#define GRIDVIEW_DIVIDER_COLOR XY_COLOR(224, 230, 236)

#define BLUE_COLOR XY_COLOR(26,128,255)
#define RED_COLOR [UIColor redColor]
#define CLEAR_COLOR [UIColor clearColor]

//字体
#define SMALL_TEXT_FONT [UIFont systemFontOfSize:13.0f] //24
#define SIMPLE_TEXT_FONT [UIFont systemFontOfSize:15.0f] //28px
#define LARGE_TEXT_FONT [UIFont systemFontOfSize:16.0f]  //30px

//通知
#define XY_NOTIFICATION_LOGIN @"NotificationLogin" //登录成功通知
#define XY_NOTIFICATION_LOGOUT @"NotificationLogout" //登出成功通知
#define XY_NOTIFICATION_REFRESH_NEW_ORDER @"NotificationNewOrderStatusChanged"//未完成订单状态求刷新
#define XY_NOTIFICATION_REFRESH_OLD_ORDER @"NotificationOldOrderStatusChanged"//已完成订单状态求刷新
#define XY_NOTIFICATION_EDIT_REPAIR_NEW_ORDER @"NotificationNewOrderStatusEdited"
#define XY_NOTIFICATION_EDIT_REPAIR_OLD_ORDER @"NotificationOldOrderStatusEdited"
#define XY_NOTIFICATION_WECHAT_SDK_PAID @"NotificationWechatSDKPaid" //微信sdk支付结果
#define XY_NOTIFICATION_REFRESH_NEW_ORDER_MAP @"NotificationRefreshNewOrderMap"

//keys
#define GAODE_REST_KEY @"ad6c2c7a01c2fec89289b2234b841584"//高德坐标转换webapi
#endif
