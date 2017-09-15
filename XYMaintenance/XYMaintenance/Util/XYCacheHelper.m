//
//  CacheHelper.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYCacheHelper.h"

@implementation XYCacheHelper

+ (void)cacheKeyValues:(id)value forKey:(NSString*)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[key stringByAppendingString:UPDATE_TIME]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (id)getValuesForKey:(NSString*)key{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

//+ (void)cacheString:(NSString*)value forKey:(NSString*)key{
//    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
//    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:[key stringByAppendingString:UPDATE_TIME]];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}
//
//+(NSString*)getStringForKey:(NSString*)key
//{
//    return [[NSUserDefaults standardUserDefaults] stringForKey:key];
//}

+(void)removeCacheForKey:(NSString*)key
{
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSDate*)lastUpdateTimeOfKey:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:[key stringByAppendingString:UPDATE_TIME]];
}

@end
