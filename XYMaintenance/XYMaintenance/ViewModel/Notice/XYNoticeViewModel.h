//
//  XYNoticeViewModel.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYNoticeCallBackDelegate <NSObject>

-(void)onNoticesLoaded:(NSArray*)array totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh;

-(void)onNoticeLoadingFailed:(NSString*)errorString;

@end

@interface XYNoticeViewModel : XYBaseViewModel

@property(assign,nonatomic)id<XYNoticeCallBackDelegate> delegate;

-(void)loadNotices:(NSInteger)startIndex;

-(void)deleteNotice:(NSString*)notice;

@end
