//
//  WebClient.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYHttpClient.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "XYCacheHelper.h"
#import "XYStrings.h"
#import "XYAPPSingleton.h"
#import "MJExtension.h"
#import "AppDelegate.h"
#import "XYConfig.h"
#import "XYStringUtil.h"
#import "XYHttpSignUtil.h"


/**
 *  BaseURL 根据测试，开发，联调，发布等不同情况更换
 */
#warning https! 同时修改info.plist!
static NSString *const XYM_API_BASE_URL = @"https://api.hiweixiu.com/";//工程师
//static NSString *const XYU_API_BASE_URL = @"https://userapi.hiweixiu.com/";//用户
//static NSString *const XYM_API_BASE_URL = @"http://test-api.hiweixiu.com/";//外网线上测试

/**
 *  超时间隔
 */
static NSTimeInterval const XYM_TIMEOUT_INTERVAL = 20;

@interface XYHttpClient ()
@property (nonatomic, strong) AFHTTPSessionManager *operationManager;
@property (nonatomic, strong) NSMutableDictionary *dispatchTable;//当前请求记录表
@property (nonatomic, strong) NSNumber *recordedRequestId;//请求ID
@end


@implementation XYHttpClient

+ (id)sharedInstance{
    static dispatch_once_t onceToken;
    static XYHttpClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYHttpClient alloc] init];
    });
    return sharedInstance;
}

#pragma mark - properties

- (AFHTTPSessionManager *)operationManager{
    if (!_operationManager){
        _operationManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:XYM_API_BASE_URL]];
        _operationManager.securityPolicy = [self customSecurityPolicy];
        _operationManager.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [_operationManager.requestSerializer setTimeoutInterval:XYM_TIMEOUT_INTERVAL];
        [_operationManager.requestSerializer setValue:@"http header value" forHTTPHeaderField:@"http header field"];
         _operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
        
    }
    [_operationManager.requestSerializer setValue:[XYAPPSingleton sharedInstance].currentCookie forHTTPHeaderField:@"Cookie"];
    return _operationManager;
}

- (NSMutableDictionary *)dispatchTable{
    if (!_dispatchTable){
        _dispatchTable = [[NSMutableDictionary alloc] init];
    }
    return _dispatchTable;
}

#pragma mark - SSL setting

- (AFSecurityPolicy *)customSecurityPolicy{
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    return policy;
}

- (NSMutableDictionary*)constructParam:(NSMutableDictionary*)parameters{
    //2.封基础参数
    if(parameters == nil){
        parameters = [[NSMutableDictionary alloc]init];
    }
//    NSMutableDictionary *parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:[XYAPPSingleton sharedInstance].deviceId forKey:@"device_id"];
    [parameters setValue:[XYAPPSingleton sharedInstance].appVersion forKey:@"version"];
#ifdef __SMARTFIX //区分包 sf:魅族版 hwx:原版
    [parameters setValue:@"sf" forKey:@"app"];
#else
    [parameters setValue:@"hwx" forKey:@"app"];
#endif
    [parameters setValue:[XYAPPSingleton sharedInstance].currentUser.Id forKey:@"uid"];
    
    NSString * timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
    [parameters setValue:timestamp forKey:@"time"];
    
    return parameters;
}

#pragma mark - base request method
- (NSInteger)requestPath:(NSString *)path parameters:(NSMutableDictionary *)parameters isPost:(BOOL)isPost success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure{
    
    //1.检查网络状态
    if (([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] == NotReachable)
        && ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable)){
        failure?failure(TT_NO_NETWORK):nil;
        return -1;
    }
    
    //2.封基础参数
//    if(parameters == nil){
//        parameters = [[NSMutableDictionary alloc]init];
//    }
//    [parameters setValue:[XYAPPSingleton sharedInstance].deviceId forKey:@"device_id"];
//    [parameters setValue:[XYAPPSingleton sharedInstance].appVersion forKey:@"version"];
//#ifdef __SMARTFIX //区分包 sf:魅族版 hwx:原版
//    [parameters setValue:@"sf" forKey:@"app"];
//#else
//    [parameters setValue:@"hwx" forKey:@"app"];
//#endif
//    [parameters setValue:[XYAPPSingleton sharedInstance].currentUser.Id forKey:@"uid"];
//    
//    NSString * timestamp = [NSString stringWithFormat:@"%.0f",[[NSDate date] timeIntervalSince1970]];
//    [parameters setValue:timestamp forKey:@"time"];
    NSMutableDictionary *constructParameters = [self constructParam:parameters];
    TTDEBUGLOG(@"path = %@ paramters = %@",path,constructParameters);
    NSString *urlParampart = [XYHttpSignUtil getUrlParamPartByParameters:constructParameters];
    NSString *completeUrl = [NSString stringWithFormat:@"%@?%@", path, urlParampart];
    completeUrl = [completeUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    
    //3.设置http请求类型
    NSNumber *requestId = [self generateRequestId];
   
    if (isPost){
        NSURLSessionTask *httpRequestOperation = [self.operationManager POST:completeUrl parameters:nil progress:nil success:^(NSURLSessionTask *operation, id responseObject){
            NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
            if (!storedOperation){
                return;
            }else{
                [self.dispatchTable removeObjectForKey:requestId];
            }
            XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseObject];
            if ([path isEqualToString:DO_LOGIN] && dto.code == RESPONSE_SUCCESS){
                [self cacheCookie:operation];
            }
            if (dto.code == TICKET_INVALID) {
                [self postReLoginNotification];
            }
            TTDEBUGLOG(@"\n path = %@\n paramters = %@\n dto = %@",path,parameters,[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
            success?success(responseObject):nil;
         }failure:^(NSURLSessionTask *operation, NSError *error){
            NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
            if (storedOperation == nil){
               return;
            }else{
               [self.dispatchTable removeObjectForKey:requestId];
            }
            failure?failure(TT_NETWORK_ERROR):nil;
        }];
        self.dispatchTable[requestId] = httpRequestOperation;
    }else{
        NSURLSessionTask *httpRequestOperation = [self.operationManager GET:completeUrl parameters:nil progress:nil success:^(NSURLSessionTask *operation, id responseObject){
            NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
            if (!storedOperation){
                return;
            }else{
                [self.dispatchTable removeObjectForKey:requestId];
            }
            XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseObject];
            if (dto.code == TICKET_INVALID) {
                [self postReLoginNotification];
            }
            TTDEBUGLOG(@"\n path = %@\n paramters = %@\n dto = %@",path,parameters,[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
            success?success(responseObject):nil;
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
            if (storedOperation == nil){
                return;
            }else{
                [self.dispatchTable removeObjectForKey:requestId];
            }
            failure?failure(TT_NETWORK_ERROR):nil;

        }];
//        httpRequestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
        self.dispatchTable[requestId] = httpRequestOperation;
    }
    
    return [requestId integerValue];
}

- (NSNumber *)generateRequestId{
    if (!_recordedRequestId){
        _recordedRequestId = @(1);
    } else {
        if ([_recordedRequestId integerValue] == NSIntegerMax){
            _recordedRequestId = @(1);
        } else{
            _recordedRequestId = @([_recordedRequestId integerValue] + 1);
        }
    }
    return _recordedRequestId;
}

- (NSInteger)postBody:(NSString *)path body:(NSArray*)bodyParameter urlParameter:(NSMutableDictionary*)parameters success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure{
    
    NSMutableString *url = [[NSMutableString alloc]init];
    [url appendFormat:@"%@%@?",XYM_API_BASE_URL,path];
    if (!parameters) {
        parameters = [[NSMutableDictionary alloc]init];
    }
    [parameters setValue:[XYAPPSingleton sharedInstance].deviceId forKey:@"device_id"];
    
    for (NSString* key in [parameters allKeys]) {
        [url appendFormat:@"%@=%@&",key,parameters[key]];
    }
    NSString *postBody = [XYStringUtil dictionaryToJson:bodyParameter];
    [parameters setValue:postBody forKey:@"data"];
    
    TTDEBUGLOG(@"URL: %@\nPOST BODY :%@\n",url,postBody);
    
    NSNumber *requestId = [self generateRequestId];
    
    NSURL *URL = [NSURL URLWithString:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:XYM_TIMEOUT_INTERVAL];
    [manager.requestSerializer setValue:@"http header value" forHTTPHeaderField:@"http header field"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    NSURLSessionTask* operation = [manager POST:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        TTDEBUGLOG(@"URL: %@\nPOST BODY :%@\nDTO :%@\n",url,postBody,[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]);
        NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil){
            return;
        }else{
            [self.dispatchTable removeObjectForKey:requestId];
        }
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseObject];
        if (dto.code == TICKET_INVALID) {
            [self postReLoginNotification];
        }
        success?success(responseObject):nil;
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil){
            return;
        }else{
            [self.dispatchTable removeObjectForKey:requestId];
        }
        failure?failure(TT_NETWORK_ERROR):nil;
    }];
    
    self.dispatchTable[requestId] = operation;
    return [requestId integerValue];
}

- (NSInteger)uploadFile:(NSData*)fileData params:(NSDictionary*)params name:(NSString*)name fileName:(NSString*)fileName type:(NSString*)type path:(NSString*)path success:(void (^)(id responseJson))success failure:(void (^)(NSString *errorString))failure{
    NSNumber *requestId = [self generateRequestId];
    
    NSMutableDictionary *constructParameters = [self constructParam:[params mutableCopy]];
    NSString *urlParampart = [XYHttpSignUtil getUrlParamPartByParameters:constructParameters];
    NSString *completeUrl = [NSString stringWithFormat:@"%@?%@", path, urlParampart];
    
    NSURLSessionTask *operation = [self.operationManager POST:completeUrl parameters:nil constructingBodyWithBlock:^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileData:fileData
                                    name:name//@"insurance"
                                fileName:fileName//@"insurance.jpg"
                                mimeType:type];
    }progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
        NSURLSessionTask *storedOperation = self.dispatchTable[requestId];
        if (storedOperation == nil){
            return;
        }else{
            [self.dispatchTable removeObjectForKey:requestId];
        }
        success(responseObject);
    }failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(TT_NETWORK_ERROR);
    }];
    self.dispatchTable[requestId] = operation;
    return [requestId integerValue];
}

- (void)getRequestWithUrl:(NSString*)urlString parameters:(NSDictionary*)parameters success:(void (^)(id response))success failure:(void (^)(NSString *error))failure{
    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:XYM_TIMEOUT_INTERVAL];
    [manager.requestSerializer setValue:@"http header value" forHTTPHeaderField:@"http header field"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    if (!parameters) {
        parameters = [[NSMutableDictionary alloc]init];
    }
    [parameters setValue:[XYAPPSingleton sharedInstance].deviceId forKey:@"device_id"];
    
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseObject];
        if (dto.code == TICKET_INVALID) {
            [self postReLoginNotification];
        }
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(TT_NETWORK_ERROR);
    }];
    return;
}

- (void)getJSONRequestWithUrl:(NSString*)urlString parameters:(NSDictionary*)parameters success:(void (^)(id response))success failure:(void (^)(NSString *error))failure{
    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.requestSerializer setTimeoutInterval:XYM_TIMEOUT_INTERVAL];
    [manager.requestSerializer setValue:@"http header value" forHTTPHeaderField:@"http header field"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",nil];
    
    
    if (!parameters) {
        parameters = [[NSMutableDictionary alloc]init];
    }
    [parameters setValue:[XYAPPSingleton sharedInstance].deviceId forKey:@"device_id"];
    
    [manager GET:URL.absoluteString parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:responseObject];
        if (dto.code == TICKET_INVALID) {
            [self postReLoginNotification];
        }
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        failure(TT_NETWORK_ERROR);
    }];
    return;
}
#pragma mark - cancel requests

- (void)cancelRequestWithRequestID:(NSNumber *)requestID{
    if (!requestID) {return;}
    NSOperation *requestOperation = self.dispatchTable[requestID];
    if (requestOperation){
        [requestOperation cancel];
        [self.dispatchTable removeObjectForKey:requestID];
    }
}

- (void)cancelAllRequests{
    for (NSNumber* key in self.dispatchTable.allKeys) {
        [self cancelRequestWithRequestID:key];
    }
}

#pragma mark - cookie

- (void)cacheCookie:(NSURLSessionTask*)op{
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)(op.response);
    NSDictionary *fields= [HTTPResponse allHeaderFields];
    NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:XYM_API_BASE_URL]];
    NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
    [[XYAPPSingleton sharedInstance] cacheCookie:[requestFields objectForKey:@"Cookie"]];
}

- (void)postReLoginNotification{
    TTDEBUGLOG(@"ticket 失效了！");
    [[XYAPPSingleton sharedInstance] removeAll];
    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    [appDelegate showLoginView];
}

@end
