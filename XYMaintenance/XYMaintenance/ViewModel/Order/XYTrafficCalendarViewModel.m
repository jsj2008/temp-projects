//
//  XYTrafficCalendarViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficCalendarViewModel.h"

@interface XYTrafficCalendarViewModel ()
@property(strong,nonatomic)NSDateFormatter* formatter;
@property(strong,nonatomic)NSMutableDictionary* dayCacheDic;
//缓存日期对应的数据 nsdate xytfcday 月份数据暂不缓存
@end

@implementation XYTrafficCalendarViewModel



- (void)loadRecordOfDate:(NSDate*)date forced:(BOOL)isReload{
    
    if ((!isReload)&&[self.dayCacheDic objectForKey:[self.formatter stringFromDate:date]]) {
        if ([self.delegate respondsToSelector:@selector(onDateTrafficRecordLoaded:date:noteString:)]) {
            [self.delegate onDateTrafficRecordLoaded:true date:date noteString:nil];
        }
    }else{
        
      NSInteger requestId =  [[XYAPIService shareInstance]getTFCDailyInfoOf:[self.formatter stringFromDate:date] success:^(XYTFCDailyInfo *info) {
          [self.dayCacheDic setObject:info forKey:[self.formatter stringFromDate:date]];
          if ([self.delegate respondsToSelector:@selector(onDateTrafficRecordLoaded:date:noteString:)]) {
              [self.delegate onDateTrafficRecordLoaded:true date:date noteString:nil];
          }
          
        } errorString:^(NSString *error) {
            if ([self.delegate respondsToSelector:@selector(onDateTrafficRecordLoaded:date:noteString:)]) {
                [self.delegate onDateTrafficRecordLoaded:false date:date noteString:error];
            }
        }];
        
       [self registerRequestId:@(requestId)];
    }
}

-(XYTFCDailyInfo*)getFeeRecordOfDate:(NSDate*)date
{
    if ([self.dayCacheDic objectForKey:[self.formatter stringFromDate:date]]) {
        return [self.dayCacheDic objectForKey:[self.formatter stringFromDate:date]];
    }else{
        XYTFCDailyInfo* dto = [[XYTFCDailyInfo alloc]init];
        dto.money = 0;
        dto.count = 0;
        dto.edit = false;
        return dto;
    }
}
-(void)loadRecordOfMonth:(NSInteger)month year:(NSInteger)year;
{
    NSInteger requestId =  [[XYAPIService shareInstance]getMonthlyInfoOf:month year:year success:^(XYTFCMonthlyInfo *info) {
        
        if (info) {
            self.currentMonthInfo = info;
        }else{
            self.currentMonthInfo = [[XYTFCMonthlyInfo alloc]init];
            self.currentMonthInfo.list = [[NSArray alloc]init];
        }
        if ([self.delegate respondsToSelector:@selector(onMonthTrafficRecordLoaded:month:year:noteString:)]) {
            [self.delegate onMonthTrafficRecordLoaded:true month:month year:year noteString:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onMonthTrafficRecordLoaded:month:year:noteString:)]) {
            [self.delegate onMonthTrafficRecordLoaded:false month:month year:year noteString:error];
        }
    }];
    
    [self registerRequestId:@(requestId)];
}

#pragma mark - property

-(NSMutableDictionary*)dayCacheDic
{
    if (!_dayCacheDic) {
        _dayCacheDic = [[NSMutableDictionary alloc]init];
    }
    return _dayCacheDic;
}

-(XYTFCMonthlyInfo*)currentMonthInfo{

    if (!_currentMonthInfo) {
        _currentMonthInfo = [[XYTFCMonthlyInfo alloc]init];
        _currentMonthInfo.list = [[NSArray alloc]init];
    }
    
    return _currentMonthInfo;
}

- (NSDateFormatter*)formatter{
 
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

-(NSString*)getFormattedDate:(NSDate*)date
{
    return [self.formatter stringFromDate:date];
}


@end
