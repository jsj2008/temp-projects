//
//  XYOrderListManager.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DTO.h"
#import "XYThreadSafeDictionary.h"

typedef NS_ENUM(NSInteger, XYOrderListSegmentType) {
    XYOrderListSegmentTypeIncomplete = 0, //未完成
    XYOrderListSegmentTypeCancel = 1, //已取消
    XYOrderListSegmentTypeComplete = 2,//已完成
    XYOrderListSegmentTypeCleared = 3,//已结算
};

typedef NS_ENUM(NSInteger, XYRepairOrderListViewType) {
    XYOrderListViewTypeUnknown = -1, //未知
    XYOrderListViewTypeSearch = 0, //搜索
    XYOrderListViewTypeDailyCancelled = 4,//已取消(按天子页面）
};

typedef NS_ENUM(NSInteger, XYAllOrderListViewType) {
    XYAllOrderListViewTypeUnknown = -1, //未知
    XYAllOrderListViewTypeIncomplete = 0, //未完成
    XYAllOrderListViewTypeCompleted = 2,//已完成
    XYAllOrderListViewTypeCleared = 3, //已结算(按天获取的子页面)
};

@class ALAssetsLibrary;

@protocol XYOrderListTableViewDelegate <NSObject>
//订单相关的动作
- (void)goToAllOrderDetail:(NSString*)orderId type:(XYAllOrderType)type bid:(XYBrandType)bid;
@optional
- (void)goToCancelOrder:(NSString*)orderId bid:(XYBrandType)bid;
- (void)reloadOrderCount:(NSInteger)sum forIndex:(XYOrderListSegmentType)index;
- (void)changeStatusOfOrder:(NSString*)orderId into:(XYOrderStatus)status bid:(XYBrandType)bid;
- (void)payByWorker:(NSString*)orderId bid:(XYBrandType)bid;
- (void)payByCashOfOrder:(NSString*)orderId bid:(XYBrandType)bid;
- (void)makePhoneCall:(NSString*)phone;
- (void)goToClearFoldDay:(NSString*)dateStr;
- (void)goToCancelDay:(NSString*)dateStr;
@end

/**
 *  管理：1.支付方式开关 2.订单相关自拍 3.地图接单
 */
@interface XYOrderListManager : NSObject

+ (XYOrderListManager*)sharedInstance;
/**
 *  地图接单管理
 */
- (void)getNewOrdersForMap:(void (^)(NSArray* orderList))success;
- (void)getPoolOrdersForMap:(void (^)(NSArray* orderList))success;
- (void)getOverTimeOrdersForMap:(void (^)(NSArray* orderList))success;
/**
 *  支付方式开关管理
 */
@property(strong,nonatomic)NSMutableDictionary<NSString*,XYPayOpenModel*>* payOpenMap;//key:bid value:model
- (void)cachePayStatusSwitch:(NSArray<XYFeatureDto *> *)openMap;
- (void)loadPayStatusSwitchFromCache;
- (void)getPaymentAvailability;
/**
 *  照片缓存管理
 */
@property(strong,nonatomic)XYThreadSafeDictionary* cachedPhotosMap;//key:订单由picturedto生成的key value：订单详细信息
@property(strong,nonatomic)XYThreadSafeDictionary* uploadingPhotosMap;//key:相册链接 value:图片
@property(assign,nonatomic)BOOL photosReady;//缓存图片是否已加载完毕
@property(strong,nonatomic)ALAssetsLibrary *library;
//上传异步图片
- (void)uploadAsynImage:(NSData *)imgData bid:(XYBrandType)bid type:(XYPictureType)type order:(NSString *)orderId property:(NSString*)name result:(void (^)(BOOL isSuccess,NSString* url))result;
//批量上传
- (void)startUploadingAlbumImages;
//缓存到相册 待优化
- (void)saveImageToAlbum:(NSData*)imgData forOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name;
//根据相册url获取图片
- (void)getImageDataByAssetUrl:(NSString*)assetUrl result:(void (^)(UIImage* resultImg))success;
//根据订单号获取缓存照片
- (void)getCachedImageOfOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name result:(void (^)(UIImage* resultImg))success;
@end
