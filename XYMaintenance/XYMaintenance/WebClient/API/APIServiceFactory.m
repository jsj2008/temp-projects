//
//  APIServiceFactory.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "APIServiceFactory.h"

#import "UserAPIService.h"


@interface APIServiceFactory ()

@property (nonatomic, strong) NSMutableDictionary *serviceStorage;

@end


@implementation APIServiceFactory

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static APIServiceFactory *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[APIServiceFactory alloc] init];
    });
    return sharedInstance;
}

- (NSMutableDictionary *)serviceStorage
{
    if (_serviceStorage == nil)
    {
        _serviceStorage = [[NSMutableDictionary alloc] init];
    }
    return _serviceStorage;
}

- (XYAPIService*)getServiceWithIdentifier:(NSString *)identifier
{
    if (self.serviceStorage[identifier] == nil)
    {
        self.serviceStorage[identifier] = [self newServiceWithIdentifier:identifier];
    }
    return self.serviceStorage[identifier];
}

- (XYAPIService*)newServiceWithIdentifier:(NSString*)identifier
{
    if ([identifier isEqualToString:kXYHTTPAPIServiceUser])
    {
        return [[UserAPIService alloc]init];
    }
    return nil;
}

@end
