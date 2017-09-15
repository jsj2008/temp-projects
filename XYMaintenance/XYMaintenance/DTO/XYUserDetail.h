//
//  XYUserDetail.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYDtoContainer.h"



//订单状态
typedef NS_ENUM(NSInteger, XYUserType){
    XYUserTypeEngineer = 0,    //纯工程师
    XYUserTypeEngineerAndPromoter = 1,    //可兼职推广
    XYUserTypePromoter = 2,    //纯地推
};

typedef NS_ENUM(NSInteger, XYUserBrandType){
    XYUserBrandTypeUnknown = 0,
    XYUserBrandTypeHiWX = 1,    //Hi工程师
    XYUserBrandTypeMeizu = 6,    //有魅族权限的工程师
};

@interface XYUserDto : NSObject
@property(copy,nonatomic)NSString* Id;
@property(copy,nonatomic)NSString* Name;
@property(copy,nonatomic)NSString* Url;
@property(copy,nonatomic)NSString* realName;
@property(copy,nonatomic)NSString* mobile;
@property(assign,nonatomic)XYUserType is_promotion;
@property(assign,nonatomic)XYUserBrandType bid;
@property(assign,nonatomic)BOOL franchisee;
@end


@interface XYUserLevelInfo : NSObject

@property(strong,nonatomic)NSString* level_name;
@property(strong,nonatomic)NSString* receive_limit;
@property(strong,nonatomic)NSString* coefficient;

@end

@interface XYUserDetail : NSObject

@property(strong,nonatomic)NSString* realName;//姓名
@property(strong,nonatomic)NSString* Name;//工号
@property(assign,nonatomic)CGFloat Technology;//星级
@property(strong,nonatomic)NSString* service_type;//可维修类型
@property(strong,nonatomic)NSString* eng_region;//区域
@property(strong,nonatomic)NSString* city_name;//接单城市
@property(strong,nonatomic)NSString* total_cancel_percent;
@property(strong,nonatomic)NSString* total_month_after_sale;
@property(strong,nonatomic)NSString* total_after_sale;
@property(strong,nonatomic)NSString* after_sale_percent;
@property(strong,nonatomic)NSString* total_month_payed;
@property(strong,nonatomic)XYUserLevelInfo* level_info;
@property(strong,nonatomic)NSDictionary<NSString*,NSArray*>* town;
@property(strong,nonatomic)NSString* use_limit;
@property(strong,nonatomic)NSString* total_timeout_orders;
@property(strong,nonatomic)NSString* total_current_month_timeout_orders;
@property(strong,nonatomic)NSString* eng_points;
@property(strong,nonatomic)NSString* foregift;



@property(strong,nonatomic)NSString* townsString;

@end
