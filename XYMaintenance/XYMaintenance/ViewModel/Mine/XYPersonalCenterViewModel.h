//
//  XYPersonalCenterViewModel.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYPersonalCenterCallBackDelegate <NSObject>

- (void)onBonusLoaded:(BOOL)success note:(NSString*)noteStr;

@end


@interface XYPersonalCenterViewModel : XYBaseViewModel

@property(assign,nonatomic) id<XYPersonalCenterCallBackDelegate> delegate;

@property(strong,nonatomic) XYBonusDto* bonusData;
@property(assign,nonatomic) NSInteger noticeCount;

- (void)loadBonusData;
- (void)logout;

@end
