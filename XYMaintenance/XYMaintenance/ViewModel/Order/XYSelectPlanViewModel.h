//
//  XYSelectPlanViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseViewModel.h"

@interface XYSelectPlanViewModel : XYBaseViewModel

@property(copy,nonatomic) NSString* deviceId;
@property(copy,nonatomic) NSString* brandId;
@property(strong,nonatomic)NSArray* faultArray;
@property(strong,nonatomic)NSMutableArray* plansArray;

- (void)getAllFaults:(void (^)())success errorString:(void (^)(NSString *))error;

- (void)getPlansByFaultId:(NSString*)faultId success:(void (^)())success errorString:(void (^)(NSString *))error;
@end
