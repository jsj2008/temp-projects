//
//  XYRecycleOrderDetailViewModel.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

typedef NS_ENUM(NSInteger, XYRecycleOrderDetailCellType){
    XYRecycleOrderDetailCellTypeUnkown =  -1,    //未知
    XYRecycleOrderDetailCellTypeTitle = 0 , //section0 row0
    XYRecycleOrderDetailCellTypeDevice = 10, //section1 row0
    XYRecycleOrderDetailCellTypeUserName = 11,
    XYRecycleOrderDetailCellTypePhone = 12,
    XYRecycleOrderDetailCellTypeFullAddress = 13,
    XYRecycleOrderDetailCellTypeReserveTime = 14,
    XYRecycleOrderDetailCellTypeUserRemark = 15,
    
    XYRecycleOrderDetailCellTypePayType = 20,
    XYRecycleOrderDetailCellTypePayAccount = 21,
    XYRecycleOrderDetailCellTypeFinalPriceAndPay = 22,
    XYRecycleOrderDetailCellTypeSerialNumber = 23,//
};


@protocol XYRecycleOrderDetailCallBackDelegate <NSObject>
- (void)onOrderLoaded:(BOOL)success noteString:(NSString*)errorString;
- (void)onSetOff:(BOOL)success noteString:(NSString*)errorString;
@end


@interface XYRecycleOrderDetailViewModel : XYBaseViewModel

//视图
@property(strong,nonatomic)NSArray* titleArray;
- (XYRecycleOrderDetailCellType)getCellTypeByPath:(NSIndexPath*)path;
- (NSString*)getTitleByPath:(NSIndexPath*)path;
- (NSString*)getContentByPath:(NSIndexPath*)path;
- (BOOL)getSelectableByType:(XYRecycleOrderDetailCellType)type;
- (BOOL)shouldHightLight:(NSIndexPath*)path;

//订单
@property(strong,nonatomic)XYRecycleOrderDetail* orderDetail;
@property(assign,nonatomic)id<XYRecycleOrderDetailCallBackDelegate> delegate;
- (void)loadOrderDetail:(NSString*)orderId;
- (void)setOff;
- (BOOL)isBeforeOrderDone;

@end
