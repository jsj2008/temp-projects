//
//  XYPICCPhotoCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPhotoBigImageView.h"

@protocol XYPICCPhotoCellDelegate <NSObject>
- (void)takePictureWithName:(NSString*)name;
@end

static NSString *xy_photo_cell_equip_pic1 = @"equip_pic1";
static NSString *xy_photo_cell_equip_pic2 = @"equip_pic2";
static NSString *xy_photo_cell_idcard_pic1 = @"idcard_pic1";
static NSString *xy_photo_cell_idcard_pic2 = @"idcard_pic2";


@interface XYPICCPhotoCell : UITableViewCell<XYPhotoBigImageViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *equip_pic1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *equip_pic2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idcard_pic1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *idcard_pic2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *equip_alert1;
@property (weak, nonatomic) IBOutlet UIImageView *equip_alert2;
@property (weak, nonatomic) IBOutlet UIImageView *idcard_alert1;
@property (weak, nonatomic) IBOutlet UIImageView *idcard_alert2;

@property (strong,nonatomic) NSURL* equip_pic1;
@property (strong,nonatomic) NSURL* equip_pic2;
@property (strong,nonatomic) NSURL* idcard_pic1;
@property (strong,nonatomic) NSURL* idcard_pic2;

@property(assign,nonatomic) BOOL canRetakePhoto;//
@property(strong,nonatomic) NSString* currentPictureTakenName;//当前正在拍摄的图片名称 fuckkkkk

@property (assign,nonatomic) id<XYPICCPhotoCellDelegate> delegate;

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;

- (void)setUrl:(NSString*)url forName:(NSString*)name;
@end
