//
//  XYSelectDeviceViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYBaseViewModel.h"

typedef NS_ENUM(NSUInteger, XYSelectDeviceType) {
    XYSelectDeviceTypeUnknown = -1, //
    XYSelectDeviceTypePhone = 0, //手机
    XYSelectDeviceTypePad = 1    //平板
};

@interface XYSelectDeviceViewModel : XYBaseViewModel

@property (strong,nonatomic) NSMutableDictionary* deviceMap;
@property (strong,nonatomic) NSArray* brandsArray;
@property (strong,nonatomic) NSMutableArray* itemsArray;
@property (assign,nonatomic) NSInteger currentBrandIndex;

@property (strong,nonatomic) NSString* brandId;//指定brandId;没有则显示全部

- (void)updateDevicesByBrandIndex:(NSInteger)brandIndex andType:(XYSelectDeviceType)type;
- (void)getAllDevices:(XYOrderDeviceType)type success:(void (^)())success errorString:(void (^)(NSString *))error;

@end
