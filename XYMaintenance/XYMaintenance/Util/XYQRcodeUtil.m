//
//  XYQRcodeUtil.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYQRcodeUtil.h"
#import <CoreImage/CoreImage.h>

@implementation XYQRcodeUtil

/**
 *  根据字符串生成二维码 CIImage 对象
 *
 *  @param urlString 需要生成二维码的字符串
 *
 *  @return 生成的二维码
 */
+ (UIImage *)creatQRcodeWithUrlstring:(NSString *)urlString size:(CGSize)size{
    // 1.实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复滤镜的默认属性 (因为滤镜有可能保存上一次的属性)
    [filter setDefaults];
    // 3.将字符串转换成NSdata
    NSData *data  = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    // 4.通过KVO设置滤镜, 传入data, 将来滤镜就知道要通过传入的数据生成二维码
    [filter setValue:data forKey:@"inputMessage"];
    // 5.生成二维码
    CIImage *outputImage = [filter outputImage];
    return [XYQRcodeUtil changeImageSizeWithCIImage:outputImage andSize:size.width];
}

+ (UIImage *)changeImageSizeWithCIImage:(CIImage *)ciImage andSize:(CGFloat)size{
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成带logo的二维码
 *  二维码和logo都是正方形的
 *  @param urlString     二维码中的链接
 *  @param QRCodeCGRect  二维码的CGRect
 *  @param logoImage     二维码中的logo
 *  @param logoImageSize logo的大小
 *  @param cornerRadius  logo的圆角值大小
 *
 *  @return 生成的二维码
 */
+ (UIImage *)creatQRCodeWithURLString:(NSString *)urlString size:(CGSize)wholeSize logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius{
    
    UIImage *qrImage = [XYQRcodeUtil creatQRcodeWithUrlstring:urlString size:wholeSize]; // 生成二维码
    if (logoImage != nil) {
        if (cornerRadius < 0) {
            cornerRadius = 0;
        }
        qrImage = [XYQRcodeUtil addImageToSuperImage:qrImage withSubImage:logoImage andSubImagePosition:CGRectMake((wholeSize.width - logoImageSize.width)/2, (wholeSize.height - logoImageSize.height)/2, logoImageSize.width, logoImageSize.height)]; // 增加logo
    }
    return qrImage;
}

+ (UIImage *)addImageToSuperImage:(UIImage *)superImage withSubImage:(UIImage *)subImage andSubImagePosition:(CGRect)posRect{
    UIGraphicsBeginImageContext(superImage.size);
    [superImage drawInRect:CGRectMake(0, 0, superImage.size.width, superImage.size.height)];
    //四个参数为水印图片的位置
    [subImage drawInRect:posRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
