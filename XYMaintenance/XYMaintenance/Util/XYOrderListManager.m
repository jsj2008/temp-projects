//
//  XYOrderListManager.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/1/20.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOrderListManager.h"
#import "API.h"
#import "XYAPPSingleton.h"
#import "XYConfig.h"
#import "XYKeychainUtil.h"
#import "XYCacheHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "XYWidgetUtil.h"
#import "XYLocationManagerWithTimer.h"
#import <ImageIO/ImageIO.h>

#import <YYImageCache.h>

@implementation XYOrderListManager

+ (XYOrderListManager*)sharedInstance{
    static dispatch_once_t onceToken;
    static XYOrderListManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYOrderListManager alloc] init];
//        [sharedInstance getCachedMapFromKeyChain];//防止重复初始化
        [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    });
    return sharedInstance;
}

- (void)applicationEnterForeground{
    //进入前台时，
    //1.获取最新的支付开关
    [self getPaymentAvailability];
}

- (void)getNewOrdersForMap:(void (^)(NSArray* orderList))success{
    //地图“今日预约”
    [[XYAPIService shareInstance]getTodayMapOrderList:1 success:^(NSArray *orderList, NSInteger sum) {
        success(orderList);
    } errorString:^(NSString *error) {
        success(nil);
    }];
}

- (void)getPoolOrdersForMap:(void (^)(NSArray* orderList))success{
     //地图“接单地图”
    [[XYAPIService shareInstance]getPoolOrderList:1 success:^(NSArray *orderList, NSInteger sum) {
        success(orderList);
    } errorString:^(NSString *error) {
        success(nil);
    }];
}

- (void)getOverTimeOrdersForMap:(void (^)(NSArray* orderList))success{
    //地图“超时”
    [[XYAPIService shareInstance]getOverTimeMapOrderList:1 success:^(NSArray *orderList) {
        success(orderList);
    } errorString:^(NSString *error) {
        success(nil);
    }];
}

#pragma mark - 订单支付开关
//缓存
- (void)cachePayStatusSwitch:(NSArray<XYFeatureDto *> *)openList{
    self.payOpenMap = [NSMutableDictionary dictionaryWithDictionary: [XYPayOpenModel convert:openList]];
    TTDEBUGLOG(@"self.payOpenMap:%@",[self.payOpenMap mj_keyValues]);
    [XYFeatureDto save:openList];
}

//加载缓存 如无缓存则默认全部关闭
- (void)loadPayStatusSwitchFromCache{
    NSArray<XYFeatureDto*>* array = [XYFeatureDto loadFeatures];
    if (array) {
        self.payOpenMap = [NSMutableDictionary dictionaryWithDictionary: [XYPayOpenModel convert:array]];
    }else{
        self.payOpenMap = [NSMutableDictionary dictionary];
    }
    TTDEBUGLOG(@"self.payOpenMap:%@",[self.payOpenMap mj_keyValues]);
}

- (void)getPaymentAvailability{
    [[XYAPIService shareInstance]getPayOpenList:^(NSArray<XYFeatureDto *> *openList) {
        [[XYOrderListManager sharedInstance] cachePayStatusSwitch:openList];
    } errorString:^(NSString *error) {
        //获取失败，不管，以缓存为准即可
        TTDEBUGLOG(@"error:%@",error);
        [self performSelector:@selector(getPaymentAvailability) withObject:nil afterDelay:15];
    }];
}

#pragma mark - album & keychain

//取出缓存图片
- (void)getCachedMapFromKeyChain{
    self.photosReady = false;
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //子线程遍历缓存图片，
        TTDEBUGLOG(@"dispatch_get_global_queue thread:%@",[NSThread currentThread]);
        dispatch_group_enter(group);
        NSString* spJsonStr = [XYKeychainUtil load:kCachedPhotos];
        TTDEBUGLOG(@"spJsonStr = %@",spJsonStr);
        NSDictionary* spJsonDic = [spJsonStr mj_JSONObject];
        [self.cachedPhotosMap initDicContent:spJsonDic];
        for(NSString* orderKey in [self.cachedPhotosMap cachedKeys]){
            dispatch_group_enter(group);
            [self.cachedPhotosMap objectForKey:orderKey block:^(NSDictionary *dict, NSString *key, id object)    {
                NSString* jsonStr = (NSString*)object;
                TTDEBUGLOG(@"key=%@,url=%@,dict=%@",orderKey,jsonStr,dict);
                if (jsonStr) {
                    XYPictureDto* dto = [XYPictureDto dtoFromJsonString:jsonStr];
                    [self getImageDataByAssetUrl:dto.assetUrl?dto.assetUrl:@"" result:^(UIImage *resultImg) {
                        if (resultImg) {
                            [self.uploadingPhotosMap setObject:resultImg forKey:dto.assetUrl?dto.assetUrl:@"" block:^(NSDictionary *dict, NSString *key, id object) {
                                TTDEBUGLOG(@"uploadSelfPhotoImage thread:%@",[NSThread currentThread]);
                                dispatch_group_leave(group);
                            }];
                        }else{
                            dispatch_group_leave(group);
                        }
                    }];
                }else{
                    dispatch_group_leave(group);
                }
            }];
        }
        dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            self.photosReady = true;
            TTDEBUGLOG(@"dispatch_group_notify thread:%@ %@ %@",[NSThread currentThread],[self.cachedPhotosMap jsonStr],@([self.uploadingPhotosMap numberOfItemsInDic]));
        });
    });
    
}

- (XYThreadSafeDictionary*)cachedPhotosMap{
    if (!_cachedPhotosMap) {
        _cachedPhotosMap = [[XYThreadSafeDictionary alloc]init];
    }
    return _cachedPhotosMap;
}

- (XYThreadSafeDictionary*)uploadingPhotosMap{
    if (!_uploadingPhotosMap) {
        _uploadingPhotosMap = [[XYThreadSafeDictionary alloc]init];
    }
    return _uploadingPhotosMap;
}

- (ALAssetsLibrary*)library{
    if (!_library) {
        _library = [[ALAssetsLibrary alloc]init];
    }
    return _library;
}

- (void)saveImageToAlbum:(NSData*)imgData forOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //2016需求：缓存到本地相册。。。 而不是沙盒/数据库。。。orz
        [self.library writeImageDataToSavedPhotosAlbum:imgData metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
            TTDEBUGLOG(@"assetURL = %@",assetURL);
            if(assetURL && (!error)){
                [self.uploadingPhotosMap setObject:[UIImage imageWithData:imgData] forKey:[NSString stringWithFormat:@"%@",assetURL] block:^(NSDictionary *dict, NSString *key, id object) {}];
                //url等信息存到keychain，以防删包后丢失
                NSString* picJsonStr = [XYPictureDto jsonStringWithOrderId:orderId url:[NSString stringWithFormat:@"%@",assetURL] bid:bid type:type name:name];
                //Keychain
                [self.cachedPhotosMap setObject:picJsonStr forKey:[XYPictureDto keyWithOrderId:orderId bid:bid type:type name:name] block:^(NSDictionary *dict, NSString *key, id object) {
                    TTDEBUGLOG(@"save %@",[dict mj_JSONString]);
                    [XYKeychainUtil save:kCachedPhotos data:[dict mj_JSONString]];
                    TTDEBUGLOG(@"current keychain:%@",[XYKeychainUtil load:kCachedPhotos]);
                }];
            }
        }];
    });
}

- (void)startUploadingAlbumImages{
    dispatch_group_t group = dispatch_group_create();
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_group_enter(group);
        //子线程遍历缓存图片，
        TTDEBUGLOG(@"dispatch_get_global_queue thread:%@",[NSThread currentThread]);
            for(NSString* orderKey in [self.cachedPhotosMap cachedKeys]){
                [self.cachedPhotosMap objectForKey:orderKey block:^(NSDictionary *dict, NSString *key, id object)    {
                    NSString* jsonStr = (NSString*)object;
                    TTDEBUGLOG(@"key=%@,url=%@,dict=%@",orderKey,jsonStr,dict);
                    if (jsonStr) {
                        XYPictureDto* dto = [XYPictureDto dtoFromJsonString:jsonStr];
                        [self.uploadingPhotosMap objectForKey:dto.assetUrl?dto.assetUrl:@"" block:^(NSDictionary *dict, NSString *key, id object) {
                            UIImage* resultImg = (UIImage*)object;
                            if (resultImg) {
                                [self uploadAsynImage:[XYWidgetUtil resetSizeOfImageData:resultImg maxSize:100] bid:dto.bid type:dto.type order:dto.orderId property:dto.name result:^(BOOL success, NSString* url) {
                                    if (success) {
                                        [self.cachedPhotosMap setObject:nil forKey:orderKey block:^(NSDictionary *dict, NSString *key, id object) {
                                            dispatch_group_leave(group);
                                        }];
                                    }else{
                                        dispatch_group_leave(group);
                                    }
                                    TTDEBUGLOG(@"uploadSelfPhotoImage thread:%@",[NSThread currentThread]);
                                }];
                            }else{
                                dispatch_group_leave(group);
                            }
                        }];
                    }else{
                        dispatch_group_leave(group);
                    }
                }];
            }
            dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [XYKeychainUtil save:kCachedPhotos data:[self.cachedPhotosMap jsonStr]];
            TTDEBUGLOG(@"dispatch_group_notify thread:%@",[NSThread currentThread]);
            });
    });
}

//[NSURLRequestInternal _libraryIsAvailable]: unrecognized selector sent to instance
- (void)getImageDataByAssetUrl:(NSString*)assetUrl result:(void (^)(UIImage* resultImg))success{
    TTDEBUGLOG(@"getImageDataByAssetUrl = %@",assetUrl);
    dispatch_semaphore_t sema = dispatch_semaphore_create(1);
    [self.library assetForURL:[NSURL URLWithString:assetUrl] resultBlock:^(ALAsset *asset) {
        dispatch_semaphore_signal(sema);
#warning 加载缓存注释掉, 如果要用读取缓存，先测试
//        success([UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]]);
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage* image = [self fullSizeImageForAssetRepresentation:asset.defaultRepresentation];
            dispatch_async(dispatch_get_main_queue(), ^{
                success(image);
            });
        });
    } failureBlock:^(NSError *error) {
        TTDEBUGLOG(@"asset error:%@",error);
        dispatch_semaphore_signal(sema);
        success(nil);
    }];
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
}

-(UIImage *)fullSizeImageForAssetRepresentation:(ALAssetRepresentation *)assetRepresentation
{
    UIImage *result = nil;
    NSData *data = nil;
    
    uint8_t *buffer = (uint8_t *)malloc(sizeof(uint8_t)*[assetRepresentation size]);
    if (buffer != NULL) {
        NSError *error = nil;
        NSUInteger bytesRead = [assetRepresentation getBytes:buffer fromOffset:0 length:[assetRepresentation size] error:&error];
        data = [NSData dataWithBytes:buffer length:bytesRead];
        
        free(buffer);
    }
    
    if ([data length])
    {
        CGImageSourceRef sourceRef = CGImageSourceCreateWithData((__bridge CFDataRef)data, nil);
        
        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        
        [options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceShouldAllowFloat];
        [options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceCreateThumbnailFromImageAlways];
        [options setObject:(id)[NSNumber numberWithFloat:640.0f] forKey:(id)kCGImageSourceThumbnailMaxPixelSize];
        //[options setObject:(id)kCFBooleanTrue forKey:(id)kCGImageSourceCreateThumbnailWithTransform];
        
        CGImageRef imageRef = CGImageSourceCreateThumbnailAtIndex(sourceRef, 0, (__bridge CFDictionaryRef)options);
        
        if (imageRef) {
            result = [UIImage imageWithCGImage:imageRef scale:[assetRepresentation scale] orientation:(UIImageOrientation)[assetRepresentation orientation]];
            CGImageRelease(imageRef);
        }
        
        if (sourceRef)
            CFRelease(sourceRef);
    }
    
    return result;
}

- (void)uploadAsynImage:(NSData *)imgData bid:(XYBrandType)bid type:(XYPictureType)type order:(NSString *)orderId property:(NSString*)name result:(void (^)(BOOL isSuccess,NSString* url))result{
    
    if (![[XYAPPSingleton sharedInstance] hasLogin]) {//没登录就不传了
        result(false,nil);
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

- (void)getCachedImageOfOrder:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type property:(NSString*)name result:(void (^)(UIImage* img))result{
    NSString* key = [XYPictureDto keyWithOrderId:orderId bid:bid type:type name:name];
    [self.cachedPhotosMap objectForKey:key block:^(NSDictionary *dict, NSString *key, id object) {
        NSString* jsonStr = (NSString*)object;
        TTDEBUGLOG(@"orderId=%@,url=%@",orderId,jsonStr);
        if (jsonStr) {
            XYPictureDto* dto = [XYPictureDto dtoFromJsonString:jsonStr];
            [self.uploadingPhotosMap objectForKey:dto.assetUrl?dto.assetUrl:@"" block:^(NSDictionary *dict, NSString *key, id object) {
                result((UIImage*)object);
            }];
        }else{
            result(nil);
        }
    }];
}

//#pragma mark - 图片缓存异步上传 -废弃 需求：重新安装包后依然可传，改为存入系统相册
//- (NSMutableSet*)unUploadedImageKeysSet{
//    if (!_unUploadedImageKeysSet) {
//        _unUploadedImageKeysSet = [NSMutableSet setWithArray:[self unUploadedImageKeysArrayFromCache]];
//    }
//    return _unUploadedImageKeysSet;
//}
//
//- (NSArray*)unUploadedImageKeysArrayFromCache{
//    return [XYCacheHelper getValuesForKey:kUploadImages];
//}
//
//- (void)startUploadingCachedImages{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        //子线程遍历缓存图片，
//        @synchronized(self.unUploadedImageKeysSet) {
//            NSEnumerator<NSString*>* enumerator = [self.unUploadedImageKeysSet objectEnumerator];
//            NSString* orderId ;
//            NSMutableSet* deleteSet = [[NSMutableSet alloc]init];
//            while ((orderId = [enumerator nextObject])) {
//                if (![[YYImageCache sharedCache]containsImageForKey:orderId]) {
//                    //本地没有图片的orderId记录待删除
//                    [deleteSet addObject:orderId];
//                }else{
//                    //如存在图片则上传，
//                    [[YYImageCache sharedCache] getImageDataForKey:orderId withBlock:^(NSData * _Nullable imageData) {
//                        [self uploadSelfPhotoImage:imageData repeatCount:0 order:orderId result:^(NSInteger repeatCount, BOOL success) {
//                            if (success) {
//                                //上传成功后清理图片
//                                [[YYImageCache sharedCache] removeImageForKey:orderId];
//                            }
//                        }];
//                    }];
//                }
//            }
//            //统一删除
//            for (NSString* orderToDelete in deleteSet) {
//                [self.unUploadedImageKeysSet removeObject:orderToDelete];
//                [XYCacheHelper cacheKeyValues:[NSArray arrayWithArray:[self.unUploadedImageKeysSet allObjects]] forKey:kUploadImages];
//            }
//        }
//    });
//}
//
//
//- (void)cacheImage:(NSData*)imgData forOrder:(NSString*)orderId{
//    @synchronized(self.unUploadedImageKeysSet) {
//        [self.unUploadedImageKeysSet addObject:orderId];
//        [XYCacheHelper cacheKeyValues:[NSArray arrayWithArray:[self.unUploadedImageKeysSet allObjects]] forKey:kUploadImages];
//    }
//    [[YYImageCache sharedCache]setImage:nil imageData:imgData forKey:orderId withType:YYImageCacheTypeDisk];
//}

@end
