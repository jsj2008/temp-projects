//
//  XYURLResponse.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, XYURLResponseStatus)
{
    XYURLResponseStatusSuccess,      //成功
    XYURLResponseStatusErrorTimeout, //超时
    XYURLResponseStatusErrorNoNetwork,//无网络
    XYURLResponseStatusErrorFail     //失败
};

/**
 *  http请求之响应封装
 */
@interface XYURLResponse : NSObject

@property (nonatomic, assign, readonly) NSInteger requestId;
@property (nonatomic, assign, readonly) XYURLResponseStatus status;
@property (nonatomic, copy, readonly) id jsonContent;
@property (nonatomic, copy, readonly) NSString *errorString;
@property (nonatomic, assign, readonly) BOOL isCache;
@property (nonatomic, copy) NSString* cookie;

//服务端返回的结果
- (id)initWithRequestId:(NSNumber *)requestId status:(XYURLResponseStatus)status responseContent:(id)content errorString:(NSString*)error;

//缓存的记录 //缓存逻辑待定
- (id)initWithCachedJson:(NSString*)json;

@end
