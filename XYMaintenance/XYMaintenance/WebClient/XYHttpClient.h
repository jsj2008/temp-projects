//
//  WebClient.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger  RESPONSE_SUCCESS = 200;   //成功
static NSInteger  RESPONSE_NO_CONTENT = 403;
static NSInteger  TICKET_INVALID =   401;    //被顶号了,ticket失效了

static NSString* const DO_LOGIN = @"activities/login";//登录
static NSString* const LOG_OUT = @"activities/logout";//登出

/**
 *  Http请求基础管理类
 */
@interface XYHttpClient : NSObject

/**
 *  单例
 */
+ (XYHttpClient*)sharedInstance;


- (void)postReLoginNotification;

/**
 *  普通get/post请求发起
 *
 *  @param path       接口路径
 *  @param parameters 参数
 *  @param isPost     是post还是get
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 请求编号（用于撤销请求）
 */
- (NSInteger)requestPath:(NSString *)path parameters:(NSMutableDictionary *)parameters isPost:(BOOL)isPost success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure;

/**
 *  游离于base_url之外的url请求
 *
 *  @param urlString  url
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)getRequestWithUrl:(NSString*)urlString parameters:(NSDictionary*)parameters success:(void (^)(id response))success failure:(void (^)(NSString* error))failure;

/**
 *  游离于base_url之外的url请求
 *
 *  @param urlString  url
 *  @param parameters 参数 JSON数据类型
 *  @param success    成功回调
 *  @param failure    失败回调
 */
- (void)getJSONRequestWithUrl:(NSString*)urlString parameters:(NSDictionary*)parameters success:(void (^)(id response))success failure:(void (^)(NSString *error))failure;

/**
 *  postBody请求 body为json
 *
 *  @param path       接口路径
 *  @param parameters 参数
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  @return 请求编号（用于撤销请求）
 */
- (NSInteger)postBody:(NSString *)path body:(NSArray *)bodyParameter urlParameter:(NSMutableDictionary*)parameters success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure;

/**
 *  上传文件
 *
 *  @param fileData 文件data
 *  @param name     参数名
 *  @param type     类型
 *  @param success  成功回调
 *  @param failure    失败回调
 *
 *  @return 请求编号（用于撤销请求）
 */
- (NSInteger)uploadFile:(NSData*)fileData params:(NSDictionary*)params name:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type path:(NSString*)path success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure;


/**
 *  撤销请求
 *
 *  @param requestId 请求编号
 */
- (void)cancelRequestWithRequestID:(NSNumber*)requestId;

/**
 *  撤销所有请求
 */
- (void)cancelAllRequests;

@end
