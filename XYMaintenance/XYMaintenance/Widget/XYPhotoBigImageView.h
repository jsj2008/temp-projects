//
//  XYPhotoBigImageView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/23.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XYPhotoBigImageViewDelegate <NSObject>
//重拍
- (void)retakePicture:(NSString*)picName;
@end

//全屏大图
@interface XYPhotoBigImageView : UIView
@property(strong,nonatomic)UIImageView* imageView;
@property(strong,nonatomic)UIButton* retakeButton;
@property(copy,nonatomic)NSString* picName;
@property(assign,nonatomic)id<XYPhotoBigImageViewDelegate> delegate;

+ (void)showBigImageWithUrl:(NSURL*)url name:(NSString*)picName canRetake:(BOOL)canRetake delegate:(id<XYPhotoBigImageViewDelegate>)delegate;

- (void)hidePhotoBigImageView;

@end
