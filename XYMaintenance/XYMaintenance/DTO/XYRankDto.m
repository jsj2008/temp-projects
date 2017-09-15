//
//  XYRankDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/12/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRankDto.h"

@implementation XYRankDto
@end

@implementation XYRankListDataDto
@end

@implementation XYRankListDto
@end

@implementation XYPromotionRankDto
+ (NSString*)getPictureNameByCity:(NSString*)city{
    return [NSString stringWithFormat:@"city_%@",city];
}
@end

@implementation XYPromotionRankListDto
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"my_data" : @"self",
             };
}
@end

@implementation XYPromotionRankListDataDto
@end

