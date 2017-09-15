//
//  XYAPIService+V10API.h
//  XYMaintenance
//
//  Created by lisd on 2017/2/21.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V10API)
/**
 *  公告分类列表
 *
 *
 *  @return requestId
 */
- (NSInteger)getNewsSortList:(void (^)(NSArray* newsSortList,NSInteger sum))success errorString:(void (^)(NSString *))error;

/**
 *  配件申请额度
 *
 *
 *  @return requestId
 */
- (NSInteger)getPartAmountSuccess:(void (^)(XYPartsAmountDto* partsAmountDto))success errorString:(void (^)(NSString *))error;

/**
 *  配件申请批次
 *
 *  @param searchStartTime 起始时间
 *  @param searchEndTime 终止时间
 *  @param page 页码
 *
 *  @return requestId
 */
- (NSInteger)getPartsApplyLogFrom:(NSString*)searchStartTime to:(NSString*)searchEndTime page:(NSInteger)page success:(void (^)(NSArray* partsLogList,NSInteger sum))success errorString:(void (^)(NSString *))errorString;

/**
 *  配件申请批次详情
 *
 *
 *  @return requestId
 */
- (NSInteger)getPartsApplyLogDetailByApplyLogId:(NSString*)applyLogId success:(void (^)(NSArray* partsLogDetailList,NSInteger sum))success errorString:(void (^)(NSString *))errorString;

/**
 *  申请配件
 *
 *
 *  @return requestId
 */
- (NSInteger)submitParts:(NSArray*)parts success:(void (^)())success errorString:(void (^)(NSString *))errorString;

/**
 *  开关配置
 *
 *
 *  @return requestId
 */
- (NSInteger)getSwitchConfiguration:(void (^)(XYConfigDto* config))success errorString:(void (^)(NSString *))errorString;

@end
