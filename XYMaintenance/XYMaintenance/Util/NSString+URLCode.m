//
//  NSString+URLCode.m
//  XYHiRepairs
//
//  Created by 吴伟 on 16/8/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "NSString+URLCode.h"

@implementation NSString (URLCode)
//加密
- (NSString *)URLEncode{
    NSString *outputStr = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                              kCFStringEncodingUTF8));
    return outputStr;
}

//解密
- (NSString *)URLDecode{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end
