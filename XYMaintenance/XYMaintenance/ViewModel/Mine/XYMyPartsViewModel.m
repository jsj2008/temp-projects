//
//  XYMyPartsViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYMyPartsViewModel.h"

@implementation XYMyPartsViewModel

- (void)loadMyPartsList{
    [[XYAPIService shareInstance]getMyPartsList:^(NSArray *partsList) {
        [self.delegate onPartsLoaded:partsList?partsList:[[NSArray alloc]init] success:true note:nil];
    } errorString:^(NSString *error) {
        [self.delegate onPartsLoaded:nil success:false note:error];
    }];
}

- (void)loadApplyRecord:(NSInteger)p startDate:(NSString*)start endDate:(NSString*)end{
    [[XYAPIService shareInstance] getPartsApplyLogFrom:start to:end page:p success:^(NSArray *partsLogList, NSInteger sum) {
        [self.delegate onApplyLoaded:partsLogList total:sum isRefresh:(p==1) success:true note:nil];
    } errorString:^(NSString *err) {
        [self.delegate onApplyLoaded:nil total:0 isRefresh:(p==1) success:false note:err];
    }];
}

- (void)loadClaimRecord:(NSInteger)p{
    [[XYAPIService shareInstance]getClaimRecordsList:p success:^(NSArray *recordsList, NSInteger sum) {
         [self.delegate onRecordsLoaded:recordsList?recordsList:[[NSArray alloc]init] total:sum isRefresh:(p==1) success:true note:nil];
    } errorString:^(NSString *error) {
        [self.delegate onRecordsLoaded:nil total:0 isRefresh:NO success:false note:error];
    }];
}

- (void)confirmClaimRecord:(NSString*)claimId bid:(XYBrandType)bid{
    [[XYAPIService shareInstance] confirmClaiming:claimId bid:bid success:^{
        [self.delegate onClaimingRecord:claimId success:true note:nil];
    } errorString:^(NSString *error) {
        [self.delegate onClaimingRecord:claimId success:false note:error];
    }];
}

- (void)loadPartsFlow:(NSInteger)p startDate:(NSString*)start endDate:(NSString*)end part:(NSString*)partId{
    [[XYAPIService shareInstance]getMyPartsFlowListFrom:start to:end part:partId page:p success:^(NSArray *partsList, NSInteger sum) {
        [self.delegate onPartsFlowLoaded:partsList total:sum isRefresh:(p==1) success:true note:nil];
    } errorString:^(NSString *err) {
        [self.delegate onPartsFlowLoaded:nil total:0 isRefresh:(p==1) success:false note:err];
    }];
}

@end
