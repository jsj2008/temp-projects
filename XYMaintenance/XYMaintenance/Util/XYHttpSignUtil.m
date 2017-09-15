//
//  XYHttpSignUtil.m
//  XYMaintenance
//
//  Created by 李思迪 on 2017/8/20.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYHttpSignUtil.h"
#import "CocoaSecurity.h"
#import "BBAES.h"
#import "NSString+URLCode.h"
//static NSString* const sha256_salt = @"@O6R$4dfaSL$v&V%TCOJDk9gNLnxA!c8";

@implementation XYHttpSignUtil

+ (NSString *)sha256_salt {
    return @"@O6R$4dfaSL$v&V%TCOJDk9gNLnxA!c8";
};

+ (NSString *)getUrlParamPartByParameters:(NSMutableDictionary*)parameters {
    NSMutableString *contentMutableString  =[NSMutableString string];
    NSArray *keys = [parameters allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        [contentMutableString appendFormat:@"%@=%@&", categoryId, [parameters valueForKey:categoryId]];
    }
    //字符串删减处理
    NSString *contentString = [contentMutableString stringByReplacingOccurrencesOfString:@" " withString:@""];
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSString *lastCharacter = [contentString substringFromIndex: [contentString length] - 1];
    if ([lastCharacter isEqualToString:@"&"]) {
        contentString = [contentString substringToIndex:[contentString length]-1];
    }
    //拿到sign
    NSString *sign = [self getHttpSign:contentString];
    contentString = [NSString stringWithFormat:@"%@&sign=%@", contentString, sign];

    return contentString;
};
    
+ (NSString *)getHttpSign:(NSString*)contentString{
    NSString *rawData = contentString;
    NSString *rawData_urlEncoded = [rawData URLEncode];
    NSString *rawData_salted = [NSString stringWithFormat:@"%@%@", rawData_urlEncoded, [self sha256_salt]];
    CocoaSecurityResult *result = [CocoaSecurity sha256:rawData_salted];
    NSString *sign = result.hex;
    NSString *sign_base64 = [sign base64EncodedString];
    NSString *sign_base64_urlEncoded = [sign_base64 URLEncode];
    
    return sign_base64_urlEncoded;
}


@end
