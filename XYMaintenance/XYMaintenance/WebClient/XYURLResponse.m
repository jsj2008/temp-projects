//
//  XYURLResponse.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYURLResponse.h"
#import "XYConfig.h"

@implementation XYURLResponse

//服务端返回结果
- (id)initWithRequestId:(NSNumber *)requestId status:(XYURLResponseStatus)status responseContent:(id)content errorString:(NSString*)error
{
    self = [super init];
    if (self)
    {
        _requestId = [requestId integerValue];
        _status = status;
        _jsonContent = content;
        _errorString = error ? error : @"";
        _isCache = NO;
        
        if (!error)
        {
            NSError* e;
            
           NSString *str = [NSJSONSerialization JSONObjectWithData:content options:NSJSONReadingMutableContainers error:&e];
            if (!e)
            {
                TTDEBUGLOG(@"recievedBody:%@", str);
            }
            else
            {
                TTDEBUGLOG(@"e = %@",e);
            }
        }
       
    }
    return self;
}



//缓存记录
- (id)initWithCachedJson:(NSString*)json
{
    self = [super init];
    if (self)
    {
        _requestId = 0;
        _status = XYURLResponseStatusSuccess;
        _jsonContent = [json dataUsingEncoding:NSUTF8StringEncoding];
        _errorString = @"";
        _isCache = YES;
    }
    return self;
}

- (XYURLResponseStatus)responseStatusWithError:(NSError *)error
{
    if (error)
    {
        XYURLResponseStatus result = XYURLResponseStatusErrorFail;
        
        if (error.code == NSURLErrorTimedOut)
        {
            result = XYURLResponseStatusErrorTimeout;
        }
        
        return result;
    }
    else
    {
        return XYURLResponseStatusSuccess;
    }
}


@end
