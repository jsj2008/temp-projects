//
//  LoginViewModel.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYLoginViewModel.h"
#import "XYCacheHelper.h"
#import "MJExtension.h"
#import "JPUSHService.h"
#import "XYOrderListManager.h"

@implementation XYLoginViewModel

- (id)init{
    if (self = [super init]) {
        [self loadCachedInputInfo];
    }
    return self;
}

/**
 *  缓存的输入记录
 */
- (void)loadCachedInputInfo{
    NSDictionary* loginInfo = [XYCacheHelper getValuesForKey:kLoginInfo];
    if (loginInfo) {
        self.preAccount = XY_NOTNULL([loginInfo valueForKey:kXYLoginCacheKeyAccount],@"");
        self.prePassword = XY_NOTNULL([loginInfo valueForKey:kXYLoginCacheKeyPassword],@"");
    }
}

- (void)getVerifyCode:(NSString*)account{
    [[XYAPIService shareInstance]getVerifyCode:account success:^{
        if ([self.delegate respondsToSelector:@selector(onVerifyCodeSent:note:)]) {
           [self.delegate onVerifyCodeSent:true note:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onVerifyCodeSent:note:)]) {
            [self.delegate onVerifyCodeSent:false note:error];
        }
    }];
}

- (void)doLoginWithAccount:(NSString*)account password:(NSString*)password code:(NSString*)code{
    [[XYAPIService shareInstance] doLoginWithAccount:account password:password code:code  success:^(XYUserDto *user) {
        [[XYAPPSingleton sharedInstance] cacheUser:user account:account pwd:password];
        [self initFeatureAvailability];
        [self setAlias];
        if ([self.delegate respondsToSelector:@selector(onLoginResult:note:)]) {
           [self.delegate onLoginResult:true note:nil];
        }
        
    } errorString:^(NSString *error){
        if ([self.delegate respondsToSelector:@selector(onLoginResult:note:)]) {
            [self.delegate onLoginResult:false note:error];
        }
    }];
}

- (void)setAlias{
    [JPUSHService setAlias:[XYAPPSingleton sharedInstance].currentUser.Name callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    
    if (iResCode!=0) {
        TTDEBUGLOG(@"注册别名失败！%@",@(iResCode));
         [self performSelector:@selector(setAlias) withObject:nil afterDelay:5];
    }else{
        TTDEBUGLOG(@"注册别名成功！");
    }
}

- (void)initFeatureAvailability{
    
    //现金支付开关
    //当前逻辑：获取功能列表
    //如有该功能，取其状态
    //如果没有 取缓存
    //缓存也没有 默认功能guanbi =-=
    
    [[XYOrderListManager sharedInstance] loadPayStatusSwitchFromCache];
    [[XYOrderListManager sharedInstance] getPaymentAvailability];
}





@end
