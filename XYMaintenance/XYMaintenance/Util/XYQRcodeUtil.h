//
//  XYQRcodeUtil.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/29.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYQRcodeUtil : NSObject
//无logo纯二维码
+ (UIImage *)creatQRcodeWithUrlstring:(NSString *)urlString size:(CGSize)size;

//带logo的二维码
+ (UIImage *)creatQRCodeWithURLString:(NSString *)urlString size:(CGSize)wholeSize logoImage:(UIImage *)logoImage logoImageSize:(CGSize)logoImageSize logoImageWithCornerRadius:(CGFloat)cornerRadius;
@end
