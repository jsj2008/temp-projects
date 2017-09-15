//
//  XYRankDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/12/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYRankingListType) {
    XYRankingListTypeTodayCountry = 0, //今日全国
    XYRankingListTypeTodayCity = 1, //今日城市
    XYRankingListTypeMonthCountry = 2,//本月全国
    XYRankingListTypeMonthCity = 3,//本月城市
    XYRankingListTypePromotionCity = 4,//城市地推
    XYRankingListTypePromotionPerson = 5,//个人地推
};


@interface XYRankDto : NSObject
@property(copy,nonatomic)NSString* engineer_name;//工号
@property(copy,nonatomic)NSString* image_url;
@property(copy,nonatomic)NSString* city_name;
@property (nonatomic,assign)NSInteger order_num;
@property (nonatomic,assign)CGFloat push_money;
@property (nonatomic,assign)NSInteger key;


@property (nonatomic,assign)NSInteger weixiu_push_money;
@property (nonatomic,assign)NSInteger weixiu_order_num;
@property (nonatomic,assign)NSInteger insurance_push_money;
@property (nonatomic,assign)NSInteger insurance_order_num;
@property (nonatomic,assign)NSInteger shr_push_money;
@property (nonatomic,assign)NSInteger shr_order_num;

@end

@interface XYRankListDto : NSObject
@property(strong,nonatomic)XYRankDto* my_mess;
@property(strong,nonatomic)NSArray<XYRankDto*>* all_list;
@end

@interface XYRankListDataDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)XYRankListDto* data;
@property(copy,nonatomic)NSString* mes;
@end


@interface XYPromotionRankDto : NSObject
@property(copy,nonatomic)NSString* city;
@property(copy,nonatomic)NSString* name;
@property(assign,nonatomic)NSInteger total_engineer_counts;
@property(assign,nonatomic)NSInteger total_promotion_counts;
@property(copy,nonatomic)NSString* avg_counts;
@property(copy,nonatomic)NSString* engineer_id;
@property(copy,nonatomic)NSString* Name;
@property(copy,nonatomic)NSString* region_name;
@property(assign,nonatomic)NSInteger counts;
@property(assign,nonatomic)NSInteger month_counts;
@property(copy,nonatomic)NSString* Url;

+ (NSString*)getPictureNameByCity:(NSString*)city;
//排名
@property (nonatomic,assign)NSInteger key;
@end

@interface XYPromotionRankListDto : NSObject
@property(strong,nonatomic)XYPromotionRankDto* my_data;
@property(strong,nonatomic)NSArray<XYPromotionRankDto*>* datas;
@property(assign,nonatomic)NSInteger sum;
@end

@interface XYPromotionRankListDataDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)XYPromotionRankListDto* data;
@property(copy,nonatomic)NSString* mes;
@end

