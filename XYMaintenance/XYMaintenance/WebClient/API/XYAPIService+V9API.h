//
//  XYAPIService+V9API.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V9API)

/**
 *  配件流水
 *
 *  @param searchStartTime 起始时间
 *  @param searchEndTime 终止时间
 *  @param part_id 筛选配件id
 *
 *  @return requestId
 */
- (NSInteger)getMyPartsFlowListFrom:(NSString*)searchStartTime to:(NSString*)searchEndTime part:(NSString*)part_id page:(NSInteger)page success:(void (^)(NSArray* partsList,NSInteger sum))success errorString:(void (^)(NSString *))errorString;

/**
 *  配件筛选项
 *
 *  @param mould_id 起始时间
 *  @param fault_id 终止时间
 *  @param color_id 颜色
 *
 *  @return requestId
 */
- (NSInteger)getPartsFlowSelectionsByDevice:(NSString*)mould_id fault:(NSString*)fault_id color:(NSString*)color_id success:(void (^)(NSArray* partsList))success errorString:(void (^)(NSString *))errorString;

@end
