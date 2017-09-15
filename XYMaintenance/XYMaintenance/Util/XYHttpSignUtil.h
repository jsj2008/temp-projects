//
//  XYHttpSignUtil.h
//  XYMaintenance
//
//  Created by 李思迪 on 2017/8/20.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYHttpSignUtil : NSObject

+ (NSString *)getUrlParamPartByParameters:(NSMutableDictionary*)parameters;
@end
