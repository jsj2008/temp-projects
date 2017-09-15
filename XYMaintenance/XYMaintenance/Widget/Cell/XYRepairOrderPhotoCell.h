//
//  XYRepairOrderPhotoCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/8.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPhotoBigImageView.h"
#import "XYPictureDto.h"

@protocol XYRepairOrderPhotoCellDelegate <NSObject>
- (void)takePictureWithName:(NSString*)name;
- (void)uploadPicture:(UIImage*)img name:(NSString*)name;
@end


@interface XYRepairOrderPhotoCell : UITableViewCell<XYPhotoBigImageViewDelegate>

@property(assign,nonatomic) BOOL canRetakePhoto;//
@property(strong,nonatomic) NSString* currentPictureTakenName;//当前正在拍摄的图片名称 fuckkkkk
@property (assign,nonatomic) id<XYRepairOrderPhotoCellDelegate> delegate;

+ (NSString*)defaultReuseId;
+ (CGFloat)getHeightByVIP:(BOOL)isVip;//是否需要vip证件照片

- (void)setVip:(BOOL)isVip;
- (void)setUrl:(NSString*)url localImage:(UIImage*)img forName:(NSString*)name;

@end






