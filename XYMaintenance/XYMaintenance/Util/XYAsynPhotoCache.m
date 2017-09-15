//
//  XYAsynImageCache.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/13.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAsynPhotoCache.h"
#import "XYAPPSingleton.h"
#import "API.h"
#import "XYLocationManagerWithTimer.h"

#define XYDocumentDirectory [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
static const NSString* XYAsynPhotoPrefix = @"XYAsynPhoto_";

@implementation XYAsynPhotoCache

+ (XYAsynPhotoCache*)sharedInstance{
    static dispatch_once_t onceToken;
    static XYAsynPhotoCache *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYAsynPhotoCache alloc] init];
        [sharedInstance initCachedPhotos];
    });
    return sharedInstance;
}

- (YYThreadSafeDictionary*)cachedPhotosInfoMap{
    if (!_cachedPhotosInfoMap) {
        _cachedPhotosInfoMap = [[YYThreadSafeDictionary alloc]init];
    }
    return _cachedPhotosInfoMap;
}

- (YYThreadSafeDictionary*)cachedPhotosImageMap{
    if (!_cachedPhotosImageMap) {
        _cachedPhotosImageMap = [[YYThreadSafeDictionary alloc]init];
    }
    return _cachedPhotosImageMap;
}

//初始化缓存照片信息
- (void)initCachedPhotos{
    
}

//缓存单张图片及其附带信息
- (void)savePhoto:(NSData*)imgData forOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSString* key = [XYPictureDto keyWithOrderId:orderId bid:bid type:type name:name];
        NSString* fullPath = [XYDocumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.jpg",XYAsynPhotoPrefix,key]];
        [imgData writeToFile:fullPath atomically:YES];
    });
}

//根据订单号等信息获取单张缓存照片
- (UIImage*)getCachedPhotoOfOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name{
    NSString* key = [XYPictureDto keyWithOrderId:orderId bid:bid type:type name:name];
    NSString* fullPath = [XYDocumentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@.jpg",XYAsynPhotoPrefix,key]];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    return savedImage;
}

//批量上传
- (void)startUploadingAllPhotos{
    //NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:XYDocumentDirectory error:nil];
    //遍历 上传
    //return files;
}

//异步上传单张图片
- (void)uploadAsynPhoto:(NSData *)imgData bid:(XYBrandType)bid type:(XYPictureType)type order:(NSString *)orderId property:(NSString *)name result:(void (^)(BOOL, NSString *))result{

    if (![[XYAPPSingleton sharedInstance] hasLogin]) {//没登录就不传了
        result(false,nil);
        return;
    }
    if (!imgData) {
        return;
    }
    //传图
    [[XYAPIService shareInstance]uploadImage:imgData type:type parameters:@{@"user_name":[XYAPPSingleton sharedInstance].currentUser.Name} success:^(NSString *url){

        switch (type) {
            case XYPictureTypeSelfPhotoTaking:
            {
                //传自拍照片时要定位！！orz!
                [[XYLocationManagerWithTimer sharedManager].locationManager requestLocationWithReGeocode:true completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                    //关联订单号
                    [[XYAPIService shareInstance]editWorkerSelfTaking:orderId bid:bid photo:url lng:[NSString stringWithFormat:@"%@",@(location.coordinate.longitude)] lat:[NSString stringWithFormat:@"%@",@(location.coordinate.latitude)] addr:regeocode.formattedAddress?regeocode.formattedAddress:[NSString stringWithFormat:@"lat:%@,lng:%@",@(location.coordinate.latitude),@(location.coordinate.longitude)] success:^{
                        result(true,url);
                    } errorString:^(NSString *err) {
                        result(false,nil);
                    }];
                }];
            }
                break;
            case XYPictureTypeWechat:
            {
                //关联订单号
                [[XYAPIService shareInstance]addWechatPromotionPhoto:url order:orderId bid:bid success:^{
                    result(true,url);
                } errorString:^(NSString *err) {
                    result(false,nil);
                }];
            }
                break;
            case XYPictureTypeReceipt:
            {
                //关联订单号
                [[XYAPIService shareInstance]editReceiptOfOrder:orderId bid:bid url:url success:^{
                    result(true,url);
                } errorString:^(NSString *err) {
                    result(false,nil);
                }];
            }
                break;
            case XYPictureTypeRepairNumber:
            {
                [[XYAPIService shareInstance]editRepairOrder:orderId bid:bid photo1:[name isEqualToString:xy_photo_cell_devno_pic1]?url:nil photo2:[name isEqualToString:xy_photo_cell_devno_pic2]?url:nil photo3:[name isEqualToString:xy_photo_cell_devno_pic3]?url:nil photo4:[name isEqualToString:xy_photo_cell_devno_pic4]?url:nil success:^{
                    result(true,url);
                } errorString:^(NSString *err) {
                    result(false,nil);
                }];
            }
                break;
            default:
                break;
        }

    } errorString:^(NSString *error) {
        result(false,nil);
    }];
}

@end
