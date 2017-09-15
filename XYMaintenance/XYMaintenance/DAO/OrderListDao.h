//
//  OrderListDao.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/6.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDtoContainer.h"

@interface OrderListDao : NSObject

+(BOOL)insertOrder:(XYPHPOrderBase*)orderBase;

+(BOOL)saveOrderList:(NSArray*)orderList;

+(XYPHPOrderBase*)findOrderById:(NSString*)orderId;

+(BOOL)updateOrder:(XYPHPOrderBase*)order;

+(NSArray*)getAllOrders;

+(BOOL)removeOrderById:(NSString*)orderId;

+(void)removeAll;

@end
