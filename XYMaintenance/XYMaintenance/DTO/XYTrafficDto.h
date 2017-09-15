//
//  XYTrafficDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XYTFCDailyInfo : NSObject
@property(assign,nonatomic)CGFloat money;
@property(assign,nonatomic)NSInteger count;
@property(assign,nonatomic)BOOL edit;
@end

@interface XYTFCSimpleInfo : NSObject
@property(assign,nonatomic)NSInteger count;
@property(assign,nonatomic)CGFloat money;
@end


@interface XYTFCMonthlyInfo : NSObject
@property(strong,nonatomic)XYTFCSimpleInfo* info;
@property(strong,nonatomic)NSArray* list;
@end

@interface XYMonthlyFeeDto : NSObject
@property(copy,nonatomic)NSString* date;
@property(copy,nonatomic)NSString* money;
@end

@interface XYTrafficRecordDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* start_point;
@property(copy,nonatomic)NSString* end_point;
@property(copy,nonatomic)NSString* fare;
@property(copy,nonatomic)NSString* operate;
@end

@interface XYTrafficOrderLocDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* FinishTime;
@property(copy,nonatomic)NSString* address;
@end