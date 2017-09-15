//
//  APIServiceFactory.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYAPIService.h"

//把所有http接口拆分成几个service，如用户，订单，交易，用相应key标记并以工厂方法获取 （ 粒度是否有必要细化到单个api？？小工程。。。 ）
static NSString * const kXYHTTPAPIServiceUser = @"kXYHTTPAPIServiceUser";


@interface APIServiceFactory : NSObject

+ (instancetype)sharedInstance;

- (XYAPIService*)getServiceWithIdentifier:(NSString *)identifier;

@end
