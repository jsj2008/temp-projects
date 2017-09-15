//
//  XYAPPSingleton.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/16.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTO.h"

/**
 *  管理当前用户状态/全局状态/设备系统版本参数等
 */
@interface XYAPPSingleton : NSObject
//用户
@property(retain,nonatomic) XYUserDto* currentUser;
@property (strong,nonatomic) XYWorkerStatusDto* workerStatus;
//登录状态
@property(copy,nonatomic) NSString* currentCookie;
@property(copy,nonatomic) NSString* deviceId;//设备唯一id
//app参数
@property(copy,nonatomic,readonly) NSString* appVersion;
@property(copy,nonatomic,readonly) NSString* build;
@property(copy,nonatomic,readonly) NSString* appName;
@property(copy,nonatomic,readonly) NSString* appScheme;

+ (XYAPPSingleton*)sharedInstance;

- (BOOL)hasLogin;
- (BOOL)isFirstLoginToday;
- (void)recordTimeOnLaunch;

//app水印
- (void)updateWaterMark:(XYUserDto*)user;
- (void)setWaterMarkHidden:(BOOL)hidden;

//cookie缓存相关
- (void)loadCachedData;
- (void)cacheCookie:(NSString*)cookie;
- (void)cacheUser:(XYUserDto*)user account:(NSString*)account pwd:(NSString*)password;
- (void)removeCookie;
- (void)removeAll;

//UI权限
- (BOOL)shouldBlockBonusInRankList; //魅族工程师 不显示提成
- (BOOL)shouldBlockCreateOrderButton; //魅族工程师 不显示添加订单

@end
