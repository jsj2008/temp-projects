//
//  XYOrderListViewModel.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYOrderListCallBackDelegate <NSObject>

/**
 *  新订单列表
 */
- (void)onNewOrderListsLoaded:(BOOL)success orders:(NSArray*)ordersArray totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh noteString:(NSString*)noteString;

/**
 *  已完成列表
 *
 */
- (void)onDoneOrderListsLoaded:(BOOL)success orders:(NSArray*)ordersArray totalCount:(NSInteger)totalCount isRefresh:(BOOL)isRefresh noteString:(NSString*)noteString;

@optional

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


@interface XYOrderListViewModel : XYBaseViewModel

@property(assign,nonatomic) id<XYOrderListCallBackDelegate> delegate;

- (void)loadUndoneOrderLists:(NSInteger)p;

- (void)turnStateOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid;

- (void)payOrderByCash:(NSString*)orderId bid:(XYBrandType)bid;

@end
