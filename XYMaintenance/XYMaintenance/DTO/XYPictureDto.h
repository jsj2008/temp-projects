//
//  XYPictureDto.h
//  XYMaintenance
//
//  Created by Kingnet on 16/11/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XYDtoContainer.h"

typedef NS_ENUM(NSInteger, XYPictureType) {
    XYPictureTypeInsurance = 0,    //保险
    XYPictureTypeUserSign = 1,     //用户签名
    XYPictureTypeRepairNumber = 2,    //维修订单序列号图片
    XYPictureTypeSelfPhotoTaking = 3, //工程师自拍
    XYPictureTypeReceipt = 4, //发票
    XYPictureTypeWechat = 5,  //微信推广截图
};

//普通照片cell
static NSString *xy_photo_cell_devno_pic1 = @"devnopic1";
static NSString *xy_photo_cell_devno_pic2 = @"devnopic2";
static NSString *xy_photo_cell_devno_pic3 = @"devnopic3";//vip
static NSString *xy_photo_cell_devno_pic4 = @"devnopic4";
//魅族订单照片cell
static NSString *mz_photo_cell_devno_pic1 = @"devnopic1";
static NSString *mz_photo_cell_devno_pic2 = @"devnopic2";
static NSString *mz_photo_cell_devno_pic3 = @"devnopic3";//魅族vip
static NSString *mz_photo_cell_receipt_pic = @"receipt_pic";

@interface XYPictureDto : NSObject
@property (strong,nonatomic) NSString* orderId;//关联订单号
@property (strong,nonatomic) NSString* assetUrl;//相册路径
@property (assign,nonatomic) XYBrandType bid;//所属品牌商
@property (assign,nonatomic) XYPictureType type;//照片类型
@property (strong,nonatomic) NSString* name;//参数名

+ (NSString*)jsonStringWithOrderId:(NSString*)orderId url:(NSString*)url bid:(XYBrandType)bid type:(XYPictureType)type name:(NSString*)name;
+ (NSString*)keyWithOrderId:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type name:(NSString*)name;
+ (XYPictureDto*)dtoFromJsonString:(NSString*)str;

@end
