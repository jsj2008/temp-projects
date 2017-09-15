//
//  XYOrderSearchViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/5.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderSearchViewModel.h"
#import "NSMutableArray+SWUtilityButtons.h"



@implementation XYOrderSearchViewModel


-(NSArray*)keywordsList
{
    if (!_keywordsList) {
        _keywordsList = [[NSArray alloc]init];
    }
    return _keywordsList;
}

-(void)findKeywordsByString:(NSString*)str{

}

-(void)doSearchWithKeyword:(NSString*)keyword startPage:(NSInteger)p{
    NSInteger requestId = [[XYAPIService shareInstance] searchOrderByKeyword:keyword success:^(NSArray *orderList, NSInteger sum) {
        [self.delegate onSearchResultLoaded:orderList?orderList:[[NSArray alloc]init] isRefresh:true totalCount:orderList?[orderList count]:0];
    } errorString:^(NSString *error) {
        [self.delegate onLoadingResultFailed:error];
    }];
  [self registerRequestId:@(requestId)];
}

- (void)turnStateOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid{
    
    NSInteger requestId = [[XYAPIService shareInstance] changeStatusOfOrder:orderId into:status bid:bid success:^{
            [self.delegate onStatusOfOrder:orderId changedInto:status];
        }errorString:^(NSString *error){
            [self.delegate onStatusOfOrder:orderId changingFailed:error];
        }];
    [self registerRequestId:@(requestId)];
}

- (void)payOrderByCash:(NSString *)orderId bid:(XYBrandType)bid{
    
    [[XYAPIService shareInstance] payOrderByCash:orderId bid:bid success:^{
         [self.delegate onOrderPaidByCash:orderId];
     }errorString:^(NSString *error){
         [self.delegate onStatusOfOrder:orderId changingFailed:error];
     }];
}//


@end
