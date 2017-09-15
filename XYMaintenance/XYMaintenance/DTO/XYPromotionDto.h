//
//  XYPromotionDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYPromotionType){
    XYPromotionTypeUnknown = -1,    //weizhi
    XYPromotionTypeWechat = 0,    //微信关注
    XYPromotionTypeAPPDownload = 1, //下载app
};

@interface XYPromotionBonusDto : NSObject
@property(assign,nonatomic)NSInteger countDay;
@property(assign,nonatomic)NSInteger countMonth;
@property(assign,nonatomic)NSInteger countTotal;
@end

@interface XYPromotionBonusDetail : NSObject

@property(assign,nonatomic)CGFloat created_at;
@property(assign,nonatomic)CGFloat push_money;
@property(assign,nonatomic)XYPromotionType source;

@property(copy,nonatomic)NSString* sourceStr;
@property(copy,nonatomic)NSString* recordTimeStr;

@end