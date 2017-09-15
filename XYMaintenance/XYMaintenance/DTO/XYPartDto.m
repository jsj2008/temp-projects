//
//  XYPartDto.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/24.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYPartDto.h"
#import "XYStringUtil.h"
#import "NSDate+DateTools.h"

@implementation XYPartDto
@end

@implementation XYPartRecordDto

- (NSString*)recordTimeStr{
    if ([XYStringUtil isNullOrEmpty:_recordTimeStr]) {
        _recordTimeStr = [[NSDate dateWithTimeIntervalSince1970:self.created_at]formattedDateWithFormat:@"yyyy/MM/dd"];
    }
    return _recordTimeStr;
}

- (BOOL)isConfirmed{
    return true;
}

@end

@implementation XYPartsApplyLogDto
- (NSString*)recordTimeStr{
    if ([XYStringUtil isNullOrEmpty:_recordTimeStr]) {
        _recordTimeStr = [[NSDate dateWithTimeIntervalSince1970:self.created_at]formattedDateWithFormat:@"yyyy/MM/dd"];
    }
    return _recordTimeStr;
}
@end

@implementation XYPartsApplyLogDetailDto

@end

@implementation XYPartsLogDto

@end

@implementation XYPartsSelectionDto

@end

@implementation XYPartsAmountDto

@end
