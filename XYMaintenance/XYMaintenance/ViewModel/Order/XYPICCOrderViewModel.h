//
//  XYAddPICCOrderViewModel.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"


typedef NS_ENUM(NSInteger, XYPICCOrderCellType){
    XYPICCOrderCellTypeUnkown =  -1,    //未知
    XYPICCOrderCellTypeName = 10 , //section1 row0
    XYPICCOrderCellTypePhone = 11, //section1 row1
    XYPICCOrderCellTypeAddress = 13, //section1 row3
    XYPICCOrderCellTypeTime = 14,  //section1 row4
    XYPICCOrderCellTypeDevice = 20, //section2 row0
    XYPICCOrderCellTypeCompany = 21,//section2 row2
    XYPICCOrderCellTypePlan = 22,//section2 row3
    XYPICCOrderCellTypeTotalPay = 23,//section2 row4
    XYPICCOrderCellTypeIEMI = 30,
    XYPICCOrderCellTypeRemark = 31,
    XYPICCOrderCellTypeEmail = 32,
    XYPICCOrderCellTypeIdentity = 33,
};

@protocol XYPICCOrderCallBackDelegate <NSObject>
- (void)onOrderLoaded:(BOOL)success noteString:(NSString*)errorString;
- (void)onOrderSubmitted:(BOOL)success noteString:(NSString*)errorString;
@end


@interface XYPICCOrderViewModel : XYBaseViewModel

@property(assign,nonatomic)id<XYPICCOrderCallBackDelegate> delegate;
@property(strong,nonatomic)NSArray* titleArray;
@property(strong,nonatomic)XYPICCOrderDetail* orderDetail;

- (XYPICCOrderCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByPath:(NSIndexPath*)path;
- (NSString*)getPlaceHolderByType:(XYPICCOrderCellType)type;
- (BOOL)getInputableByType:(XYPICCOrderCellType)type;
- (BOOL)getSelectableByType:(XYPICCOrderCellType)type;
- (UIKeyboardType)getKeyboardByType:(XYPICCOrderCellType)type;

- (void)setInputContent:(NSString*)content type:(XYPICCOrderCellType)type;
- (NSString*)getInputContentByPath:(NSIndexPath*)path;
- (void)setUrl:(NSString*)urlStr forName:(NSString*)name;

- (BOOL)getEditable;
- (BOOL)getUploadable;
- (BOOL)getPhotoTakingAvailable;
- (BOOL)getPhotoSavingAvailable;

- (void)getPICCOrderByOddNumber:(NSString*)odd_number;
- (void)cancelPICCOrderById:(NSString*)orderId;
- (void)submitPICCOrder;

@end

