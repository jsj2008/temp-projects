//
//  XYDtoContainer.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/29.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYBrandType) {
    XYBrandTypeUnknown = 0,
    XYBrandTypeHiWX = 1,    //Hi
    XYBrandTypeHuawei = 2,
    XYBrandTypeXiaomi = 3,
    XYBrandTypeXiaolajiao = 4,
    XYBrandTypeJinli = 5,
    XYBrandTypeMeizu = 6,    //魅族
    XYBrandTypeSony = 7,
};


/**
 *  对返回信息参数名一无所知时，默认采用mes;。。。
 */

@interface XYDtoContainer : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)NSDictionary* data;
@property(copy,nonatomic)NSString* message;
@property(copy,nonatomic)NSString* mes;
@property(copy,nonatomic)NSString* msg;
@end

@interface XYBoolDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)BOOL data;
@property(copy,nonatomic)NSString* mes;
@end

@interface XYStringDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)NSString* data;
@property(copy,nonatomic)NSString* message;
@property(copy,nonatomic)NSString* mes;
@end

@interface XYInfoDto : NSObject
@property(assign,nonatomic)NSInteger p;
@property(assign,nonatomic)NSInteger sum;
@end

@interface XYListDtoContainer : NSObject
@property(assign,nonatomic)NSInteger code;
@property(strong,nonatomic)XYInfoDto* info;
@property(strong,nonatomic)NSArray* data;
@property(copy,nonatomic)NSString* message;
@property(copy,nonatomic)NSString* msg;
@property(copy,nonatomic)NSString* mes;
@end

@interface XYSingleArrayDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)NSInteger sum;
@property(strong,nonatomic)NSArray* data;
@property(copy,nonatomic)NSString* mes;
@property(copy,nonatomic)NSString* msg;
@property(copy,nonatomic)NSString* message;
@end

@interface XYSingleIntegerDto : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)NSInteger data;
@property(copy,nonatomic)NSString* mes;
@property(copy,nonatomic)NSString* msg;
@property(copy,nonatomic)NSString* message;
@end

@interface XYPageListDtoContainer : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)NSInteger p;
@property(assign,nonatomic)NSInteger sum;
@property(strong,nonatomic)NSArray* data;
@property(copy,nonatomic)NSString* msg;
@property(copy,nonatomic)NSString* mes;
@end

@interface XYMultiplePageListDtoContainer : NSObject
@property(assign,nonatomic)NSInteger code;
@property(assign,nonatomic)NSInteger p;
@property(assign,nonatomic)NSInteger sum;
@property(strong,nonatomic)NSDictionary* data;
@property(copy,nonatomic)NSString* msg;
@property(copy,nonatomic)NSString* mes;
@end








