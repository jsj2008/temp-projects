//
//  XYStringUtil.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/17.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYStringUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation XYStringUtil

/** md5 一般加密 */
+ ( NSString *)md5String:( NSString *)str{
    const char *myPasswd = [str UTF8String ];
    unsigned char mdc[ 16 ];
    CC_MD5 (myPasswd, ( CC_LONG ) strlen (myPasswd), mdc);
    NSMutableString *md5String = [ NSMutableString string ];
    for ( int i = 0 ; i< 16 ; i++) {
        [md5String appendFormat : @"%02x" ,mdc[i]];
    }
    return md5String;
}

+ (BOOL)isNullOrEmpty:(NSString *)str{
    return (str == nil || [[XYStringUtil trimSpacesOfString:str] isEqualToString:@""]);
}

+ (BOOL)isAccountID:(NSString*)str{
    //TBD
    return ![XYStringUtil isNullOrEmpty:str];
}


+(BOOL)isPassword:(NSString*)str{
    return ![XYStringUtil isNullOrEmpty:str];
}

+ (NSString *)trimSpacesOfString:(NSString *)str{
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+(NSAttributedString*)getAttributedStringFromString:(NSString*)str lightRange:(NSString*)subStr lightColor:(UIColor*)color{
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:str];
    NSRange range= [str rangeOfString:subStr];
    [string addAttribute:NSForegroundColorAttributeName value:color range:range];
    return string;
}

+ (NSString*)urlTohttps:(NSString *)url{
    if (![url hasPrefix:@"http"]) {
        url = [NSString stringWithFormat:@"https://%@",url];
    }
    
    if ([url hasPrefix:@"http://"]) {
        url = [url stringByReplacingCharactersInRange:NSMakeRange(0, [@"http://" length]) withString:@"https://"];
    }
    return url;
}

+ (NSString *)dictionaryToJson:(id)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


@end
