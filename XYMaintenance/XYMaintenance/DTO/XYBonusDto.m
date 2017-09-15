//
//  XYBonusDto.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBonusDto.h"
#import "XYStringUtil.h"
#import "NSDate+DateTools.h"

@implementation XYBonusDto

@end

@implementation XYBonusDetailDto
-(NSString*)FinishTimeStr{
    if ([XYStringUtil isNullOrEmpty:_FinishTimeStr]) {
        _FinishTimeStr =  [[NSDate dateWithTimeIntervalSince1970:[self.FinishTime doubleValue]] formattedDateWithFormat:@"yyyy-MM-dd HH:mm"];
    }
    return _FinishTimeStr;
}
@end

@implementation XYPICCBonusDto

@end

@implementation XYRecycleBonusDto

@end