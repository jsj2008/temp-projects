//
//  XYMyPartsViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"


@protocol XYMyPartsCallBackDelegate <NSObject>

- (void)onPartsLoaded:(NSArray*)parts success:(BOOL)success note:(NSString*)noteString;
- (void)onApplyLoaded:(NSArray*)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString*)noteString;
- (void)onRecordsLoaded:(NSArray*)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString*)noteString;
- (void)onPartsFlowLoaded:(NSArray*)records total:(NSInteger)sum isRefresh:(BOOL)refresh success:(BOOL)success note:(NSString*)noteString;
- (void)onClaimingRecord:(NSString*)recordId success:(BOOL)success note:(NSString*)noteString;

@end

@interface XYMyPartsViewModel : XYBaseViewModel

@property(assign,nonatomic) id<XYMyPartsCallBackDelegate> delegate;
//配件流水筛选项
@property(copy,nonatomic)NSString* startTime;//2016-04-23
@property(copy,nonatomic)NSString* endTime;
@property(copy,nonatomic)NSString* startTime_partApplyLog;//2016-04-23
@property(copy,nonatomic)NSString* endTime_partApplyLog;
@property(copy,nonatomic)NSString* partId;
@property(copy,nonatomic)NSString* partName;

- (void)loadMyPartsList;
- (void)loadClaimRecord:(NSInteger)p;
- (void)confirmClaimRecord:(NSString*)claimId bid:(XYBrandType)bid;
- (void)loadPartsFlow:(NSInteger)p startDate:(NSString*)start endDate:(NSString*)end part:(NSString*)partId;
- (void)loadApplyRecord:(NSInteger)p startDate:(NSString*)start endDate:(NSString*)end;

@end
