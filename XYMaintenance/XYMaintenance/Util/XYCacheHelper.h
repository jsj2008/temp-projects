//
//  CacheHelper.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

#define UPDATE_TIME @"_update_time"
#define kLaunchTime @"k_launch_time"
#define kLoginInfo @"k_login_info"
#define kCurrentUser @"k_current_user"
#define kHttpRequestCookie @"k_http_request_cookie"
#define kLocationUploadInterval @"k_location_upload_interval"
#define kPayOpenList @"k_pay_open_map"
#define kUploadImages @"k_upload_images"

#define kXYLoginCacheKeyAccount @"account"
#define kXYLoginCacheKeyPassword @"password"

@interface XYCacheHelper : NSObject

/**
 *  加入缓存 value/key
 */
+ (void)cacheKeyValues:(id)value forKey:(NSString*)key;
/**
 *  取出key对应的缓存
 */
+ (id)getValuesForKey:(NSString*)key;

/**
 *  更新时间
 */
+ (NSDate*)lastUpdateTimeOfKey:(NSString*)key;

/**
 *  清空key对应的缓存
 */
+ (void)removeCacheForKey:(NSString*)key;


@end
