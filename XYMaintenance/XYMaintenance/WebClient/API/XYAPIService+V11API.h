//
//  XYAPIService+V11API.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"

@interface XYAPIService (V11API)
- (NSInteger)submitPlatformFees:(NSArray*)fees trade_number:(NSString*)trade_number success:(void (^)())success errorString:(void (^)(NSString *))errorString;

- (NSInteger)getEvaluationInfoWithAccount:(NSString*)account success:(void (^)(XYEvaluationDto* evaluationDto))success errorString:(void (^)(NSString *))error;



- (void)getReservetimeByCityID:(NSString*)city_id success:(void (^)(NSArray* dateList))success errorString:(void (^)(NSString *))errorString;
@end
