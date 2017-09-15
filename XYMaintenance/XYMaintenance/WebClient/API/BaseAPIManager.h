//
//  BaseAPIManager.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseAPIManager;

//请求参数数据源
@protocol APIManagerParamSourceDelegate <NSObject>
@required
- (NSMutableDictionary *)paramsForApi:(BaseAPIManager *)manager;
@end

//回调代理
@protocol APIManagerCallBackDelegate <NSObject>
@required
- (void)managerCallAPIDidSuccess:(BaseAPIManager *)manager;
- (void)managerCallAPIDidFailed:(NSString*)errorString;
@end

//子类协议
@protocol APIManagerProtocol <NSObject>
@required
-(NSString*)path;
-(BOOL)isPost;
-(BOOL)needAuth;
@optional
-(BOOL)shouldCache;
@end

/**
 *  单个API的封装基类
 */
@interface BaseAPIManager : NSObject

@property(readonly,assign,nonatomic) BOOL isLoading;
@property(readonly,retain,nonatomic) NSMutableArray* requestArray;
@property (nonatomic, weak) NSObject<APIManagerProtocol> *child;

@property(assign,nonatomic) id<APIManagerParamSourceDelegate> paramSource;
@property(assign,nonatomic) id<APIManagerCallBackDelegate> delegate;

/**
 *  发起请求
 */
- (NSInteger)doRequest;

/**
 *  取消请求
 */
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (BOOL)shouldCache;
@end
