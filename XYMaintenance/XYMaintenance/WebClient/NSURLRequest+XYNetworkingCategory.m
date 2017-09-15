//
//  NSURLRequest+XYNetworkingCategory.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "NSURLRequest+XYNetworkingCategory.h"
#import <objc/runtime.h>

static void *XYNetworkingRequestParams;

@implementation NSURLRequest (XYNetworkingCategory)

- (void)setRequestParams:(NSDictionary *)requestParams
{
    objc_setAssociatedObject(self, &XYNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams
{
    return objc_getAssociatedObject(self, &XYNetworkingRequestParams);
}

@end
