//
//  XYMeizuOrderPhotoCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/10/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPhotoBigImageView.h"
#import "XYPictureDto.h"

@protocol XYMeizuOrderPhotoCellDelegate <NSObject>
- (void)takePictureWithName:(NSString*)name;
- (void)uploadPicture:(UIImage*)img name:(NSString*)name;
@end

@interface XYMeizuOrderPhotoCell : UITableViewCell<XYPhotoBigImageViewDelegate>

@property(assign,nonatomic) BOOL canRetakePhoto;//
@property(strong,nonatomic) NSString* currentPictureTakenName;//当前正在拍摄的图片名称 fuckkkkk
@property (assign,nonatomic) id<XYMeizuOrderPhotoCellDelegate> delegate;

+ (NSString*)defaultReuseId;
+ (CGFloat)getHeightByVIP:(BOOL)isVip;

- (void)setVip:(BOOL)isVip;
- (void)setUrl:(NSString*)url localImage:(UIImage*)img forName:(NSString*)name;

@end
