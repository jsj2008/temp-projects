//
//  XYAPPSingleton.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/16.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYAPPSingleton.h"
#import "XYHttpClient.h"
#import "XYCacheHelper.h"
#import "XYStringUtil.h"
#import "MJExtension.h"
#import "NSDate+DateTools.h"
#import "JPUSHService.h"
#import "XYWaterMarkLabel.h"
#import "XYKeychainUtil.h"

@interface XYAPPSingleton()
@property (strong, nonatomic) XYWaterMarkLabel* waterMarkLabel;
@end

@implementation XYAPPSingleton

+ (XYAPPSingleton*)sharedInstance{
    static dispatch_once_t onceToken;
    static XYAPPSingleton *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYAPPSingleton alloc] init];
    });
    return sharedInstance;
}

- (NSString*)appVersion{
   return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}

- (NSString*)build{
   return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *) kCFBundleVersionKey];
}

- (NSString*)appName{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    return [bundleInfo valueForKey:@"CFBundleDisplayName"];
}

- (NSString*)appScheme{
    return @"xymaintenance";
}

- (NSString*)deviceId{
     if(!_deviceId){
        _deviceId = [XYKeychainUtil load:kDeviceId];
         if ([XYStringUtil isNullOrEmpty:_deviceId]) {
             _deviceId = [self generateDeviceId];
         }
     }
     return _deviceId;
}

- (NSString*)generateDeviceId{
    NSString *UUID = @"";
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    if (cfuuidString) {
        UUID = cfuuidString;
    }
    [XYKeychainUtil save:kDeviceId data:UUID];
    return UUID;
}

- (BOOL)hasLogin{
    return (![XYStringUtil isNullOrEmpty:self.currentCookie]) && self.currentUser;
}

- (NSString*)currentCookie{
    if ([XYStringUtil isNullOrEmpty:_currentCookie]) {
        _currentCookie = [XYCacheHelper getValuesForKey:kHttpRequestCookie];
    }
    return _currentCookie;
}

- (XYUserDto*)currentUser{
    if (!_currentUser) {
        _currentUser = [XYUserDto mj_objectWithKeyValues:[XYCacheHelper getValuesForKey:kCurrentUser]];
    }
    return _currentUser;
}

- (void)loadCachedData{
    self.currentUser = [XYUserDto mj_objectWithKeyValues:[XYCacheHelper getValuesForKey:kCurrentUser]];
    self.currentCookie = [XYCacheHelper getValuesForKey:kHttpRequestCookie];
    [[XYAPPSingleton sharedInstance] updateWaterMark:self.currentUser];
}

- (void)removeAll{
    self.currentUser = nil;
    [XYCacheHelper removeCacheForKey:kCurrentUser];
    [self removeCookie];
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
    [self updateWaterMark:nil];
}

- (void)cacheCookie:(NSString*)cookie{
    self.currentCookie = cookie;
    [XYCacheHelper cacheKeyValues:cookie forKey:kHttpRequestCookie];
}

- (void)cacheUser:(XYUserDto*)user account:(NSString*)account pwd:(NSString*)password{
    self.currentUser = user;
    //更新水印
    [[XYAPPSingleton sharedInstance] updateWaterMark:self.currentUser];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSDictionary *userDict = [user mj_keyValues];
        [XYCacheHelper cacheKeyValues:userDict forKey:kCurrentUser];
        NSMutableDictionary* dic = [[NSMutableDictionary alloc]init];
        [dic setValue:account forKey:kXYLoginCacheKeyAccount];
        [dic setValue:password forKey:kXYLoginCacheKeyPassword];
        [XYCacheHelper cacheKeyValues:dic forKey:kLoginInfo];
    });
}

- (void)removeCookie{
    self.currentCookie = nil;
    [XYCacheHelper removeCacheForKey:kHttpRequestCookie];
}

- (void)recordTimeOnLaunch{
    CGFloat timeStampNow = [[NSDate date]timeIntervalSince1970];
    [XYCacheHelper cacheKeyValues:[NSString stringWithFormat:@"%.0f",timeStampNow] forKey:kLaunchTime];
}

- (BOOL)isFirstLoginToday{
    @try {
        CGFloat lastLauchTime = [[XYCacheHelper getValuesForKey:kLaunchTime] doubleValue];
        NSDate *lastLauchDay = [NSDate dateWithTimeIntervalSince1970:lastLauchTime];
        [self recordTimeOnLaunch];
        return ![lastLauchDay isSameDay:[NSDate date]];
    }
    @catch (NSException *exception) {
        [self recordTimeOnLaunch];
        return true;
    }
}

#pragma mark - UI

- (BOOL)shouldBlockBonusInRankList{ //魅族工程师 不显示提成
    return self.currentUser.bid == XYUserBrandTypeMeizu;
}
- (BOOL)shouldBlockCreateOrderButton{ //魅族工程师 不显示添加订单
    return self.currentUser.bid == XYUserBrandTypeMeizu;
}

#pragma mark - action

- (XYWaterMarkLabel*)waterMarkLabel{
    if(!_waterMarkLabel){
        _waterMarkLabel = [XYWaterMarkLabel createWaterMarkLabel];
        [[UIApplication sharedApplication].keyWindow addSubview:_waterMarkLabel];
    }
    return _waterMarkLabel;
}

//app水印
- (void)updateWaterMark:(XYUserDto*)user{
    if (user) {
        NSInteger numberOfMarks = 10 + arc4random()%5 ;//账号个数 
        NSInteger angle = 45;//旋转角度
        [self.waterMarkLabel updateWithAngle:angle marks:numberOfMarks content:[NSString stringWithFormat:@"%@ 工号%@",user.realName,user.Name]];
    }else{
        [self.waterMarkLabel clearWaterMark];
    }
}

- (void)setWaterMarkHidden:(BOOL)hidden{
    self.waterMarkLabel.hidden = hidden;
}

@end
