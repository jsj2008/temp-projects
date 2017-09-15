//
//  OrderListDao.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/6.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "OrderListDao.h"
#import "LKDBHelper.h"

@implementation OrderListDao

+(BOOL)insertOrder:(XYPHPOrderBase*)orderBase
{
   return [orderBase saveToDB];
}

+(BOOL)saveOrderList:(NSArray*)orderList
{
    __block BOOL result = true;
    
    [[XYPHPOrderBase getUsingLKDBHelper] executeForTransaction:^BOOL(LKDBHelper *helper) {
        for (XYPHPOrderBase* order in orderList) {
           result = [order saveToDB];
            if (!result) {
                return false;
            }
        }
        return true;
    }];
    
    return result;
}

+(XYPHPOrderBase*)findOrderById:(NSString*)orderId
{
    NSArray* array = [XYPHPOrderBase searchWithWhere:@{@"orderId":orderId} orderBy:nil offset:0 count:1];
    
    if (array!=nil && [array count]>0)
    {
        return [array objectAtIndex:0];
    }
    
    return nil;
}

+(NSArray*)getAllOrders
{
    return [XYPHPOrderBase searchWithWhere:nil orderBy:nil offset:0 count:NSIntegerMax];
}

+(BOOL)removeOrderById:(NSString*)orderId
{
    return [[XYPHPOrderBase getUsingLKDBHelper] deleteWithTableName:@"XYOrderBase" where:@{@"orderId":orderId}];
}

+(void)removeAll
{
    [LKDBHelper clearTableData:[XYPHPOrderBase class]];
}

+(BOOL)updateOrder:(XYPHPOrderBase*)order
{
   return [XYPHPOrderBase updateToDB:order where:@{@"orderId":order.id}];
}

@end
