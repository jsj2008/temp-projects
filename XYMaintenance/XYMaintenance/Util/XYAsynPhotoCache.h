//
//  XYAsynImageCache.h
//  XYMaintenance
//
//  Created by Kingnet on 17/1/13.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYThreadSafeDictionary.h"
#import "DTO.h"

@interface XYAsynPhotoCache : NSObject

//key:由picturedto生成的key value：订单详细信息
@property(strong,nonatomic)YYThreadSafeDictionary* cachedPhotosInfoMap;
//key:由picturedto生成的key value:图片
@property(strong,nonatomic)YYThreadSafeDictionary* cachedPhotosImageMap;
//缓存图片是否已加载完毕
@property(assign,nonatomic)BOOL photosReady;

//初始化缓存照片信息
- (void)initCachedPhotos;

//缓存单张图片及其附带信息
- (void)savePhoto:(NSData*)imgData forOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name;
//根据订单号等信息获取单张缓存照片
- (UIImage*)getCachedPhotoOfOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name;

//批量上传
- (void)startUploadingAllPhotos;
//异步上传单张图片
- (void)uploadAsynPhoto:(NSData *)imgData bid:(XYBrandType)bid type:(XYPictureType)type order:(NSString *)orderId property:(NSString*)name result:(void (^)(BOOL isSuccess,NSString* url))result;

@end
