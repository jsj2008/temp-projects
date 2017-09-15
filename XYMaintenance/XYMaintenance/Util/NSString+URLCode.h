//
//  NSString+URLCode.h
//  XYHiRepairs
//
//  Created by 吴伟 on 16/8/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URLCode)
//加密
- (NSString *)URLEncode;

//解密
- (NSString *)URLDecode;
@end
