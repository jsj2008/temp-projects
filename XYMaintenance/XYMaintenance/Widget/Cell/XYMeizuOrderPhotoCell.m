//
//  XYMeizuOrderPhotoCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/10/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYMeizuOrderPhotoCell.h"
#import "XYConfig.h"
#import "UIImageView+YYWebImage.h"
#import "XYStringUtil.h"

static NSString *xy_photo_placeholder = @"photo_add";


@interface XYMeizuOrderPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic3ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo1_alert;
@property (weak, nonatomic) IBOutlet UIImageView *photo2_alert;
@property (weak, nonatomic) IBOutlet UIImageView *photo3_alert;

@property (weak, nonatomic) IBOutlet UILabel *vipTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo_vipImgView;
@property (weak, nonatomic) IBOutlet UIButton *photo_vipButton;
@property (weak, nonatomic) IBOutlet UIImageView *photo_vip_alert;

@property (strong,nonatomic) NSURL* equip_pic1;
@property (strong,nonatomic) NSURL* equip_pic2;
@property (strong,nonatomic) NSURL* equip_pic3;
@property (strong,nonatomic) NSURL* vip_pic;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo1_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo3_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo_vip_leading;

@end

@implementation XYMeizuOrderPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.photo1_leading.constant = self.photo_vip_leading.constant = self.photo3_trailing.constant = (SCREEN_WIDTH - 3 * 70)/4.0;
    self.photo1_alert.hidden = self.photo2_alert.hidden = self.photo3_alert.hidden = self.photo_vip_alert.hidden = true;
    //默认不是vip
    self.vipTitleLabel.hidden = self.photo_vipImgView.hidden = self.photo_vipButton.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYMeizuOrderPhotoCell";
}

+ (CGFloat)getHeightByVIP:(BOOL)isVip{
    return isVip?305:200;
}

- (void)setEquip_pic1:(NSURL *)equip_pic1{
    _equip_pic1 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic1.absoluteString]];
    [self.photo_pic1ImgView yy_setImageWithURL:_equip_pic1 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setEquip_pic2:(NSURL *)equip_pic2{
    _equip_pic2 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic2.absoluteString]];
    [self.photo_pic2ImgView yy_setImageWithURL:_equip_pic2 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setEquip_pic3:(NSURL *)equip_pic3{
    _equip_pic3 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic3.absoluteString]];
    [self.photo_pic3ImgView yy_setImageWithURL:_equip_pic3 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setVip_pic:(NSURL *)vip_pic{
    _vip_pic = [NSURL URLWithString:[XYStringUtil urlTohttps:vip_pic.absoluteString]];
    [self.photo_vipImgView yy_setImageWithURL:vip_pic placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setVip:(BOOL)isVip{
    self.vipTitleLabel.hidden = self.photo_vipImgView.hidden = self.photo_vipButton.hidden = !isVip;
    if(!isVip){
        self.photo_vip_alert.hidden = true;
    }
}

- (IBAction)equip_pic1Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic1 absoluteString]]){
        [self showBigImage:self.equip_pic1 name:mz_photo_cell_devno_pic1];
    }else{
        if (self.photo1_alert.hidden) {
            [self.delegate takePictureWithName:mz_photo_cell_devno_pic1];
        }else{
            [self.delegate uploadPicture:self.photo_pic1ImgView.image name:mz_photo_cell_devno_pic1];
        }
    }
}

- (IBAction)equip_pic2Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic2 absoluteString]]){
        [self showBigImage:self.equip_pic2 name:mz_photo_cell_devno_pic2];
    }else{
        if (self.photo2_alert.hidden) {
            [self.delegate takePictureWithName:mz_photo_cell_devno_pic2];
        }else{
            [self.delegate uploadPicture:self.photo_pic2ImgView.image name:mz_photo_cell_devno_pic2];
        }
    }
}

- (IBAction)equip_pic3Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic3 absoluteString]]){
        [self showBigImage:self.equip_pic3 name:mz_photo_cell_receipt_pic];
    }else{
        if (self.photo3_alert.hidden) {
            [self.delegate takePictureWithName:mz_photo_cell_receipt_pic];
        }else{
            [self.delegate uploadPicture:self.photo_pic3ImgView.image name:mz_photo_cell_receipt_pic];
        }
    }
}

- (IBAction)vip_picClicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.vip_pic absoluteString]]){
        [self showBigImage:self.vip_pic name:mz_photo_cell_devno_pic3];
    }else{
        if (self.photo_vip_alert.hidden) {
            [self.delegate takePictureWithName:mz_photo_cell_devno_pic3];
        }else{
            [self.delegate uploadPicture:self.photo_vipImgView.image name:mz_photo_cell_devno_pic3];
        }
    }
}

- (void)showBigImage:(NSURL*)imgUrl name:(NSString*)picName{
    [XYPhotoBigImageView showBigImageWithUrl:imgUrl name:picName canRetake:self.canRetakePhoto delegate:self];
}

- (void)retakePicture:(NSString *)picName{
    [self.delegate takePictureWithName:picName];
}


- (void)setUrl:(NSString*)url localImage:(UIImage*)img forName:(NSString*)name{
    
    //有url 则展示url图片
    if (![XYStringUtil isNullOrEmpty:url]) {
        if ([name isEqualToString:mz_photo_cell_devno_pic1])
        {
            self.equip_pic1 = [NSURL URLWithString:url];
            self.photo1_alert.hidden = true;
        }
        else if ([name isEqualToString:mz_photo_cell_devno_pic2])
        {
            self.equip_pic2 = [NSURL URLWithString:url];
            self.photo2_alert.hidden = true;
        }
        else if ([name isEqualToString:mz_photo_cell_devno_pic3]){
            self.vip_pic = [NSURL URLWithString:url];
            self.photo_vip_alert.hidden = true;
        }
        else if ([name isEqualToString:mz_photo_cell_receipt_pic])
        {
            self.equip_pic3 = [NSURL URLWithString:url];
            self.photo3_alert.hidden = true;
        }
        
        return;
    }
    
    //否则展示缓存图片
    if ([name isEqualToString:xy_photo_cell_devno_pic1])
    {
        self.photo_pic1ImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo1_alert.hidden = (!img);
    }
    else if ([name isEqualToString:xy_photo_cell_devno_pic2])
    {
        self.photo_pic2ImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo2_alert.hidden = (!img);
    }
    else if ([name isEqualToString:mz_photo_cell_receipt_pic])
    {
        self.photo_pic3ImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo3_alert.hidden = (!img);
    }
    else if ([name isEqualToString:xy_photo_cell_devno_pic3])
    {
        self.photo_vipImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo_vip_alert.hidden = (!img);
    }

}

@end
