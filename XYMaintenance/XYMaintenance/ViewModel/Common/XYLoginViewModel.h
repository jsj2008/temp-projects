//
//  LoginViewModel.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYLoginCallBackDelegate <NSObject>
- (void)onVerifyCodeSent:(BOOL)success note:(NSString*)note;
- (void)onLoginResult:(BOOL)success note:(NSString*)note;
@end

@interface XYLoginViewModel : XYBaseViewModel

@property(assign,nonatomic)id<XYLoginCallBackDelegate> delegate;
@property(copy,nonatomic) NSString* preAccount;
@property(copy,nonatomic) NSString* prePassword;

- (void)getVerifyCode:(NSString*)account;
- (void)doLoginWithAccount:(NSString*)account password:(NSString*)password code:(NSString*)code;

@end
