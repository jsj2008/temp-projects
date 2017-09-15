//
//  XYPartDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/24.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDtoContainer.h"

typedef NS_ENUM(NSInteger, XYPartApplyLogStatus) {
    XYPartApplyLogStatusWait = 0,    //待审核
    XYPartApplyLogStatusPass = 1,    //审核通过
    XYPartApplyLogStatusReject = 2,  //拒绝申请
    XYPartApplyLogStatusReceived = 3,  //已领取
};

@interface XYPartDto : NSObject
@property(copy,nonatomic)NSString* part_id;
@property(copy,nonatomic)NSString* serial_number;
@property(copy,nonatomic)NSString* name;
@property(assign,nonatomic)NSInteger num;
@property(assign,nonatomic)NSInteger sum;

@property(copy,nonatomic)NSString* storage_log_id;
@end

@interface XYPartApplyRecordDto : NSObject

@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* odd_number;
@property(copy,nonatomic)NSString* city_name;
@property(assign,nonatomic)NSInteger total_num;
@property(assign,nonatomic)BOOL is_receive;
@property(assign,nonatomic)CGFloat created_at;
@property(strong,nonatomic)NSArray* parts;
@property(assign,nonatomic)XYBrandType bid;

@property(copy,nonatomic)NSString* recordTimeStr;

@end

@interface XYPartRecordDto : NSObject

@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* odd_number;
@property(copy,nonatomic)NSString* city_name;
@property(assign,nonatomic)NSInteger total_num;
@property(assign,nonatomic)BOOL is_receive;
@property(assign,nonatomic)CGFloat created_at;
@property(strong,nonatomic)NSArray* parts;
@property(assign,nonatomic)XYBrandType bid;

@property(copy,nonatomic)NSString* recordTimeStr;

@end

@interface XYPartsLogDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* created_at;
@property(copy,nonatomic)NSString* operate_name;
@property(copy,nonatomic)NSString* part_id;
@property(copy,nonatomic)NSString* part_name;
@property(assign,nonatomic)NSInteger num;
@property(assign,nonatomic)NSInteger storage_left_num;
@property(copy,nonatomic)NSString* meta;
@end

@interface XYPartsApplyLogDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* engineer_id;
@property(copy,nonatomic)NSString* city_id;
@property(copy,nonatomic)NSString* total_num;
@property(copy,nonatomic)NSString* total_price;
@property(copy,nonatomic)NSString* status_name;
@property(copy,nonatomic)NSString* odd_number;
@property(copy,nonatomic)NSString* will_repair_order_counts;
@property(assign,nonatomic)XYPartApplyLogStatus status;
@property(copy,nonatomic)NSString* remark;
@property(assign,nonatomic)CGFloat created_at;
@property(copy,nonatomic)NSString* updated_at;
@property(copy,nonatomic)NSString* updated_by;

@property(copy,nonatomic)NSString* recordTimeStr;
@end


@interface XYPartsApplyLogDetailDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* log_id;
@property(copy,nonatomic)NSString* part_id;
@property(copy,nonatomic)NSString* part_num;
@property(copy,nonatomic)NSString* total_price;
@property(copy,nonatomic)NSString* created_at;
@property(copy,nonatomic)NSString* serial_number;
@property(copy,nonatomic)NSString* part_name;
@property(copy,nonatomic)NSString* mould_name;

@end

@interface XYPartsSelectionDto : NSObject
@property(copy,nonatomic)NSString* master_avg_price;
@property(copy,nonatomic)NSString* part_name;
@property(copy,nonatomic)NSString* part_id;
@property(copy,nonatomic)NSString* serial_number;
@property(copy,nonatomic)NSString* mould_name;

@property(assign,nonatomic)NSInteger count;//选择个数
@property(assign,nonatomic)BOOL isHideCellCountView;//隐藏计数器
@end

@interface XYPartsAmountDto : NSObject
@property(assign,nonatomic)CGFloat use_limit;
@property(assign,nonatomic)CGFloat use_limit_remain;

@end

