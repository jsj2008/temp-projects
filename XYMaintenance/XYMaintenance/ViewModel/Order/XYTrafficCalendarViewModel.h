//
//  XYTrafficCalendarViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYTrafficCalendarCallBackDelegate <NSObject>

-(void)onDateTrafficRecordLoaded:(BOOL)isSuccess date:(NSDate*)date noteString:(NSString*)str;
-(void)onMonthTrafficRecordLoaded:(BOOL)isSuccess month:(NSInteger)month year:(NSInteger)year noteString:(NSString*)str;

@end

@interface XYTrafficCalendarViewModel : XYBaseViewModel

@property(assign,nonatomic)id<XYTrafficCalendarCallBackDelegate>delegate;
@property(strong,nonatomic)XYTFCMonthlyInfo* currentMonthInfo;


-(XYTFCDailyInfo*)getFeeRecordOfDate:(NSDate*)date;
-(void)loadRecordOfDate:(NSDate*)date forced:(BOOL)isReload;//异步
-(void)loadRecordOfMonth:(NSInteger)month year:(NSInteger)year;

-(NSString*)getFormattedDate:(NSDate*)date;

@end
