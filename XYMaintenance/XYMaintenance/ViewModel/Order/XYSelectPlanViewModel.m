//
//  XYSelectPlanViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectPlanViewModel.h"
#import "XYPlanDetailCell.h"

@implementation XYSelectPlanViewModel


-(NSMutableArray*)plansArray{
   
    if (!_plansArray) {
        _plansArray = [[NSMutableArray alloc]init];
    }
    return _plansArray;
}

-(void)getAllFaults:(void (^)())success errorString:(void (^)(NSString *))error
{
    NSInteger requestId = [[XYAPIService shareInstance] getAllFaultsType:^(NSArray *faults)
    {
                               if (faults!=nil)
                               {
                                   self.faultArray = faults;
                               }
                               else
                               {
                                   self.faultArray  = [[NSArray alloc]init];
                               }
                               
                               success();
                           }
                           errorString:^(NSString *e)
                           {
                               error(e);
                           }];
    
    [self registerRequestId:@(requestId)];
}

-(void)getPlansByFaultId:(NSString*)faultId success:(void (^)())success errorString:(void (^)(NSString *))error
{
    NSInteger requestId = [[XYAPIService shareInstance]getRepairingPlanOfDevice:self.deviceId fault:faultId brand:self.brandId success:^(NSArray *plansArray)
    {
        [self.plansArray removeAllObjects];
                               
        if (plansArray!=nil)
        {
            for (NSInteger i = 0; i < [plansArray count]; i ++)
            {
                XYPlanDto* dto = [plansArray objectAtIndex:i];
                dto.cellHeight = [XYPlanDetailCell getCellHeightOfRepairType:dto.RepairType];
                [self.plansArray addObject:dto];
            }
        }
        
        success();
    }
    errorString:^(NSString *errorString)
    {
        error(errorString);
    }];
    
    [self registerRequestId:@(requestId)];
}

@end
