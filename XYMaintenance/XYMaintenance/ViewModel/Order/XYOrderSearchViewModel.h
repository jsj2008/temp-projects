//
//  XYOrderSearchViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/5.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYOrderSearchCallBackDelegate <NSObject>

-(void)onKeywordsFound;

-(void)onSearchResultLoaded:(NSArray*)resultList isRefresh:(BOOL)isRefresh totalCount:(NSInteger)totalCount;

-(void)onLoadingResultFailed:(NSString*)errorString;

/**
 *  改变订单状态成功
 */
-(void)onStatusOfOrder:(NSString*)orderId changedInto:(XYOrderStatus)status;

/**
 *  改变订单状态失败
 */
-(void)onStatusOfOrder:(NSString *)orderId changingFailed:(NSString*)errorString;

/**
 *  现金支付
 */
-(void)onOrderPaidByCash:(NSString *)orderId;

@end

@interface XYOrderSearchViewModel : XYBaseViewModel

@property(assign,nonatomic)id<XYOrderSearchCallBackDelegate> delegate;

@property(retain,nonatomic)NSArray* keywordsList;

-(void)findKeywordsByString:(NSString*)str;

-(void)doSearchWithKeyword:(NSString*)keyword startPage:(NSInteger)p;

-(void)turnStateOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid;

-(void)payOrderByCash:(NSString *)orderId bid:(XYBrandType)bid;

@end
