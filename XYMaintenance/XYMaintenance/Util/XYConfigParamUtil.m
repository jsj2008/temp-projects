//
//  XYConfigParamUtil.m
//  XYMaintenance
//
//  Created by lisd on 2017/8/22.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYConfigParamUtil.h"
#import "HttpCache.h"

@implementation XYConfigParamUtil
+ (void)save:(XYConfigDto*)XYConfigDto {
    [[HttpCache sharedInstance] setObject:XYConfigDto forKey:cache_switchConfig];
}


+ (XYConfigDto *)xy_config {
    XYConfigDto *config = (XYConfigDto*)[[HttpCache sharedInstance] objectForKey:cache_switchConfig];
    return config;
}

+ (NSDictionary *)jp_config{
    NSDictionary *para = [JSPatch getConfigParams];
    return para;
}





@end
