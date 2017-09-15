//
//  XYBonusDto.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

typedef NS_ENUM(NSInteger, XYBonusListCategory) {
    XYBonusListCategoryUnkown = -1,
    XYBonusListCategoryRepair = 0,    //维修
    XYBonusListCategoryInsurance = 1,    //保险
    XYBonusListCategoryRecycle = 2,   //回收
};


typedef NS_ENUM(NSInteger, XYBonusListType) {
    XYBonusListTypeUnknown = -1,
    XYBonusListTypeToday = 0,    //今天
    XYBonusListTypeMonth,    //月
    XYBonusListTypeTotal,    //总
};

//提成总状态
@interface XYBonusDto : NSObject
@property(assign,nonatomic)CGFloat day_push_money;
@property(assign,nonatomic)CGFloat mouth_push_money;
@property(assign,nonatomic)CGFloat total_push_money;
@end


//列表项
@interface XYBonusDetailDto : NSObject

@property(copy,nonatomic)NSString* id;
@property(assign,nonatomic)XYBrandType bid;
@property(copy,nonatomic)NSString* MouldName;
@property(copy,nonatomic)NSString* FinishTime;
@property(assign,nonatomic)CGFloat pushMoney;
@property(assign,nonatomic)XYOrderType order_status;
@property(copy,nonatomic)NSString* FaultType;
@property(copy,nonatomic)NSString* remark;

@property(copy,nonatomic)NSString* FinishTimeStr;

@end


//保险提成列表项
@interface XYPICCBonusDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* odd_number;
@property(copy,nonatomic)NSString* mould_name;
@property(copy,nonatomic)NSString* valid_dt;//"valid_dt": "2016-06-07 10:43:44",
@property(assign,nonatomic)CGFloat push_money;
@property(copy,nonatomic)NSString* coverage_name;
@end


@interface XYRecycleBonusDto : NSObject
@property(copy,nonatomic)NSString* id;
@property(copy,nonatomic)NSString* MouldName;
@property(assign,nonatomic)CGFloat pushMoney;
@end
