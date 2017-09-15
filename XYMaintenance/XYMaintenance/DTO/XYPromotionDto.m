//
//  XYPromotionDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPromotionDto.h"
#import "XYStringUtil.h"
#import "NSDate+DateTools.h"

@implementation XYPromotionBonusDto

@end



@implementation XYPromotionBonusDetail

- (NSString*)sourceStr{
    switch (self.source) {
        case XYPromotionTypeWechat:
            return @"微信关注";
        case XYPromotionTypeAPPDownload:
            return @"APP下载";
        default:
            break;
    }
    return @"推广类型";
}

- (NSString*)recordTimeStr{
    if ([XYStringUtil isNullOrEmpty:_recordTimeStr]) {
        _recordTimeStr = [[NSDate dateWithTimeIntervalSince1970:self.created_at]formattedDateWithFormat:@"yyyy/MM/dd"];
    }
    return _recordTimeStr;
}
@end