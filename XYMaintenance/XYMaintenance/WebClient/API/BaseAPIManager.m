//
//  BaseAPIManager.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "BaseAPIManager.h"
#import "WebClient.h"
#import "XYURLResponse.h"
#import "AFNetworkReachabilityManager.h"

@implementation BaseAPIManager

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _delegate = nil;
        _paramSource = nil;
        
        if ([self conformsToProtocol:@protocol(APIManagerProtocol)])
        {
            self.child = (id<APIManagerProtocol>)self;
        }
    }
    return self;
}

- (void)dealloc
{
    [self cancelAllRequests];
}

#pragma mark - properties

- (NSMutableArray *)requestIdList
{
    if (_requestArray == nil)
    {
        _requestArray = [[NSMutableArray alloc] init];
    }
    return _requestArray;
}

- (BOOL)isLoading
{
    return [self.requestArray count] > 0;
}

#pragma mark

-(NSInteger)doRequest
{
    NSMutableDictionary *params = self.paramSource ? [self.paramSource paramsForApi:self] : nil;
    NSInteger requestId = [self doRequestWithParameters:params];
    return requestId;
}

-(NSInteger)doRequestWithParameters:(NSMutableDictionary*)parameters
{
        
    NSInteger requestId = 0;
    
    if ([self shouldCache] && [self hasCacheWithParameters:parameters])
    {
        return 0;
    }
    
    if ([self isReachable])
    {
        requestId = [[WebClient sharedInstance] requestPath:[self.child path] parameters:parameters isPost:[self.child isPost] success:^(XYURLResponse *response)
        {
            
        }
        failure:^(XYURLResponse *response)
        {
            <#code#>
        }];
        
        
    }
    else
    {
        [self failedOnCallingAPI:nil];
        return requestId;
    }
}


- (BOOL)hasCacheWithParameters:(NSDictionary*)parameters
{
    //TBD
    return false;
}

- (BOOL)isReachable
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}




- (void)successedOnCallingAPI:(XYURLResponse *)response
{
    [self removeRequestId:response.requestId];
    [self.delegate managerCallAPIDidSuccess:self];
}

- (void)failedOnCallingAPI:(XYURLResponse *)response
{
    [self removeRequestId:response.requestId];
    [self.delegate managerCallAPIDidFailed:response.errorString];
}

- (void)cancelAllRequests
{
    [[WebClient sharedInstance] cancelRequestWithRequestIDList:self.requestIdList];
    [self.requestArray removeAllObjects];
}

- (void)cancelRequestWithRequestId:(NSInteger)requestID
{
    [self removeRequestId:requestID];
    [[WebClient sharedInstance] cancelRequestWithRequestID:@(requestID)];
}

-(void)removeRequestId:(NSInteger)requestId
{
    NSNumber *requestIDToRemove = nil;
    
    for (NSNumber *storedRequestId in self.requestArray)
    {
        if ([storedRequestId integerValue] == requestId)
        {
            requestIDToRemove = storedRequestId;
            break;
        }
    }
    
    if (requestIDToRemove)
    {
        [self.requestIdList removeObject:requestIDToRemove];
    }
}

- (BOOL)shouldCache
{
    return false;//默认不要缓存
}


@end
