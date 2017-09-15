//
//  XYStringUtil.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "XYConfig.h"


#define NUMBERSX_ONLY @"1234567890xX"
#define NUMBERS_ONLY @"1234567890"
#define NUMBERSDOT_ONLY @"1234567890."


@interface XYStringUtil : NSObject

#pragma mark - common string validator

//是否为空字符串
+ (BOOL)isNullOrEmpty:(NSString *)str;

//是否合法的登录账号格式
+ (BOOL)isAccountID:(NSString*)str;

//是否合法的密码格式
+ (BOOL)isPassword:(NSString*)str;

#pragma mark - string/object processor

//去掉字符串中的空格
+ (NSString *)trimSpacesOfString:(NSString *)str;
//彩色字符串
+ (NSAttributedString*)getAttributedStringFromString:(NSString*)str lightRange:(NSString*)subStr lightColor:(UIColor*)color;
//网址转换为https
+ (NSString*)urlTohttps:(NSString*)str;

+ (NSString *)md5String:( NSString *)str;

+ (NSString *)dictionaryToJson:(id)dic;

@end
