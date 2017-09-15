//
//  XYConfigParamUtil.h
//  XYMaintenance
//
//  Created by lisd on 2017/8/22.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYConfigDto.h"

@interface XYConfigParamUtil : NSObject

+ (void)save:(XYConfigDto*)XYConfigDto;

+ (XYConfigDto *)xy_config;

+ (NSDictionary *)jp_config;

@end
