//
//  XYAddOrderViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

typedef NS_ENUM(NSInteger, XYAddOrderCellType){
    XYAddOrderCellTypeUnknown =  -1,    //未知
    XYAddOrderCellTypeDevice = 0 , //section1 row0
    XYAddOrderCellTypeFault = 1, //section1 row1
    XYAddOrderCellTypeColor = 2, //section1 row2
    XYAddOrderCellTypeName = 3,
    XYAddOrderCellTypePhone = 4,
    XYAddOrderCellTypeVerifyCode = 5,
    XYAddOrderCellTypeCityArea = 6,
    XYAddOrderCellTypeAddress = 7,
};

@protocol XYAddOrderCallBackDelegate <NSObject>
- (void)onVerifyCodeSent:(BOOL)success note:(NSString*)note;
- (void)onOrderSubmitted:(BOOL)success noteString:(NSString*)errorString;
@end

@class AMapSearchAPI;


@interface XYAddOrderViewModel : XYBaseViewModel

//回调
@property(assign,nonatomic) id<XYAddOrderCallBackDelegate> delegate;

//设备
@property(strong,nonatomic) XYPHPDeviceDto* device;
@property(copy,nonatomic) NSString* color;
@property(copy,nonatomic) NSString* colorName;
@property(copy,nonatomic) NSString* plan;
@property(copy,nonatomic) NSString* planDescription;
//地址
@property(copy,nonatomic) NSString* cityId;
@property(copy,nonatomic) NSString* areaId;
@property(copy,nonatomic) NSString* cityName;
@property(copy,nonatomic) NSString* areaName;
//用户信息
@property(strong,nonatomic) NSString* phone;
@property(strong,nonatomic) NSString* code;
@property(strong,nonatomic) NSString* name;
@property(strong,nonatomic) NSString* address;

- (XYAddOrderCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByPath:(NSIndexPath*)path;
- (NSString*)getPlaceHolderByType:(XYAddOrderCellType)type;
- (BOOL)getInputableByType:(XYAddOrderCellType)type;
- (BOOL)getSelectableByType:(XYAddOrderCellType)type;
- (UIKeyboardType)getKeyboardByType:(XYAddOrderCellType)type;
- (NSString*)getInputContentByPath:(NSIndexPath*)path;

/**
 *  订单提交
 */
- (void)doSubmitOrderWithPhone:(NSString*)phone andName:(NSString*)name address:(NSString*)address;
- (void)getVerifyCode:(NSString*)account;
@end
