//
//  HttpCache.m
//  XYHiRepairs
//
//  Created by lisd on 16/10/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "HttpCache.h"
#import "YYCache.h"


static YYCache *_dataCache;

@implementation HttpCache

+(HttpCache *)sharedInstance{
    static dispatch_once_t onceToken;
    static HttpCache *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HttpCache alloc] init];
    });
    return sharedInstance;
}

+ (void)initialize
{
    _dataCache = [YYCache cacheWithName:NetworkResponseCache];
}

- (NSInteger)getAllHttpCacheSize
{
    return [_dataCache.diskCache totalCost];
}

- (void)removeAllHttpCache
{
    [_dataCache.diskCache removeAllObjects];
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key {
    [_dataCache setObject:object forKey:key];
}

- (id<NSCoding>)objectForKey:(NSString *)key {
    return [_dataCache objectForKey:key];
}

-(void)removeObjectForKey:(NSString *)key {
    [_dataCache removeObjectForKey:key];
}

- (BOOL)containsObjectForKey:(NSString *)key {
    return [_dataCache containsObjectForKey:key];
}



@end
