//
//  XYPersonalCenterViewModel.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYPersonalCenterViewModel.h"
#import "XYAPPSingleton.h"
#import "AppDelegate.h"

@implementation XYPersonalCenterViewModel

- (NSInteger)noticeCount{
    return 0;
}

- (void)loadBonusData{
    [[XYAPIService shareInstance] getBonusData:^(XYBonusDto *bonus) {
        self.bonusData = bonus;
        if ([self.delegate respondsToSelector:@selector(onBonusLoaded:note:)]) {
            [self.delegate onBonusLoaded:true note:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onBonusLoaded:note:)]) {
            [self.delegate onBonusLoaded:false note:error];
        }
    }];
}

- (void)logout{
    [[XYAPPSingleton sharedInstance] removeAll];
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_LOGOUT object:nil];
    [[XYAPIService shareInstance]doLogout:nil errorString:nil];
}
@end
