//
//  XYAPIService.h
//  XYMaintenance
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYHttpClient.h"
#import "MJExtension.h"
#import "DTO.h"

@interface XYAPIService : NSObject


+ (XYAPIService*)shareInstance;


/**
 *  临时缓存
 *
 *  @param result 任意obj
 *  @param path   路径
 */
- (void)cacheResult:(id)result forPath:(NSString*)path;
- (id)getObjectForPath:(NSString*)path;

/**
 *  撤销请求
 */
- (void)cancelRequestWithId:(NSNumber*)requestId;

/**
 *  登录
 *
 *  @param account    账号
 *  @param password   密码
 *  @param success    登录成功回调
 *  @param error      失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)doLoginWithAccount:(NSString*)account password:(NSString*)password code:(NSString*)code success:(void (^)(XYUserDto* user))success errorString:(void (^)(NSString *))error;

/**
 *  退出
 *
 *  @param success 登录成功回调
 *  @param error   失败错误回调
 *
 *  @return requestId
 */
- (NSInteger)doLogout:(void (^)())success errorString:(void (^)(NSString *))error;




@end
