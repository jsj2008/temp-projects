//
//  HttpCache.h
//  XYHiRepairs
//
//  Created by lisd on 16/10/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const NetworkResponseCache = @"NetworkResponseCache";
static NSString * const cache_partSelection = @"cache_partSelection";
static NSString * const cache_switchConfig = @"cache_switchConfig";
static NSString * const cache_reservetimeList = @"cache_reservetimeList";

@interface HttpCache : NSObject

+ (HttpCache *)sharedInstance;

/**
 *  获取网络缓存的总大小 bytes(字节)
 */
- (NSInteger)getAllHttpCacheSize;

/**
 *  删除所有网络缓存,
 */
- (void)removeAllHttpCache;

/**
 *  缓存
 */
- (void)setObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
 *  读取
 */
- (id<NSCoding>)objectForKey:(NSString *)key;

/**
 *  删除
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 *  存在？
 */
- (BOOL)containsObjectForKey:(NSString *)key;




@end
