//
//  XYRecycleUserInfoViewModel.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/7.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

typedef NS_ENUM(NSInteger, XYRecycleUserCellType){
    XYRecycleUserCellTypeUnkown =  -1,    //未知
    XYRecycleUserCellTypeTitle = 0 , //section0 row0
    XYRecycleUserCellTypeName = 10, //section1 row0
    XYRecycleUserCellTypePhone = 11,
    XYRecycleUserCellTypeCityArea = 12,
    XYRecycleUserCellTypeAddress = 13,
    XYRecycleUserCellTypeSerialNumber = 20,
    XYRecycleUserCellTypeIdentity = 21,
    XYRecycleUserCellTypePayType = 22,
    XYRecycleUserCellTypePayAccount = 23,
    XYRecycleUserCellTypePayPrice = 24,
    XYRecycleUserCellTypeRemark = 25,
};

@protocol XYRecycleUserInfoCallBackDelegate <NSObject>
- (void)onOrderSubmitted:(BOOL)success orderId:(NSString*)orderId noteString:(NSString*)errorString;
@end


@interface XYRecycleUserInfoViewModel : XYBaseViewModel

@property(strong,nonatomic)XYRecycleOrderDetail* orderDetail;
@property(assign,nonatomic)id<XYRecycleUserInfoCallBackDelegate> delegate;

@property(strong,nonatomic)NSArray* titleArray;

- (XYRecycleUserCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByPath:(NSIndexPath*)path;
- (NSString*)getPlaceHolderByType:(XYRecycleUserCellType)type;
- (BOOL)getInputableByType:(XYRecycleUserCellType)type;
- (BOOL)getSelectableByType:(XYRecycleUserCellType)type;
- (UIKeyboardType)getKeyboardByType:(XYRecycleUserCellType)type;

- (void)setInputContent:(NSString*)content type:(XYRecycleUserCellType)type;
- (NSString*)getInputContentByPath:(NSIndexPath*)path;

- (void)submitOrder;

- (BOOL)isUserInfoAllFilled;

@end
