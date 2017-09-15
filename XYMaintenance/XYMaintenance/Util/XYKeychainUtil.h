//
//  XYKeychainUtil.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>
#import "XYConfig.h"

#ifdef __SMARTFIX
#define kCachedPhotos @"k_smartfix_cached_photos"//照片缓存
#define kDeviceId @"k_smartfix_device_identifier"//设备id
#else
#define kCachedPhotos @"k_hwx_cached_photos"//照片缓存
#define kDeviceId @"k_hwx_device_identifier"//设备id
#endif

@interface XYKeychainUtil : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
