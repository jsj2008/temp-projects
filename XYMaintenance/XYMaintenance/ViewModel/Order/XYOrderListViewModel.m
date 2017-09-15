//
//  XYOrderListViewModel.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListViewModel.h"
#import "NSDate+DateTools.h"
#import "XYLocationManagerWithTimer.h"

@interface XYOrderListViewModel ()
@end

@implementation XYOrderListViewModel


- (void)loadUndoneOrderLists:(NSInteger)p{
    if (![XYAPPSingleton sharedInstance].hasLogin) {
        [self.delegate onNewOrderListsLoaded:false orders:nil totalCount:0 isRefresh:(p==1) noteString:nil];
        return;
    }
    [[XYAPIService shareInstance] getAllOrderList:true page:p success:^(NSArray<XYAllTypeOrderDto *> *orderList, NSInteger sum) {
        [self.delegate onNewOrderListsLoaded:true orders:orderList totalCount:sum isRefresh:(p==1) noteString:nil];
    }errorString:^(NSString *error){
        [self.delegate onNewOrderListsLoaded:false orders:nil totalCount:0 isRefresh:(p==1) noteString:error];
    }];
}

- (void)turnStateOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid{
    
    switch (status) {
        case XYOrderStatusRepaired:
            //维修完成 有额外参数
            //改在新页面处理了，废弃
            break;
        case XYOrderStatusOnTheWay:
        {   //出发 要定位
            [[XYLocationManagerWithTimer sharedManager].locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                [[XYAPIService shareInstance] setOutOrder:orderId bid:bid address:regeocode.formattedAddress lat:[NSString stringWithFormat:@"%@",@(location.coordinate.latitude)] lng:[NSString stringWithFormat:@"%@",@(location.coordinate.longitude)] success:^{
                    [self.delegate onStatusOfOrder:orderId changedInto:status];
                } errorString:^(NSString *error) {
                    [self.delegate onStatusOfOrder:orderId changingFailed:error];
                }];
            }];
        }
            break;
        default://普通情况
        {
            [[XYAPIService shareInstance] changeStatusOfOrder:orderId into:status bid:bid success:^{
                [self.delegate onStatusOfOrder:orderId changedInto:status];
            }errorString:^(NSString *error){
                [self.delegate onStatusOfOrder:orderId changingFailed:error];
            }];
        }
            break;
    }
    
}


- (void)payOrderByCash:(NSString *)orderId bid:(XYBrandType)bid{
    [[XYAPIService shareInstance] payOrderByCash:orderId bid:bid success:^{
         [self.delegate onOrderPaidByCash:orderId];
     }errorString:^(NSString *error){
         [self.delegate onStatusOfOrder:orderId changingFailed:error];
     }];
    
}//

@end
