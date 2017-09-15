//
//  XYRepairOrderPhotoCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/8.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYRepairOrderPhotoCell.h"
#import "XYConfig.h"
#import "UIImageView+YYWebImage.h"
#import "XYStringUtil.h"

static NSString *xy_photo_placeholder = @"photo_add";


@interface XYRepairOrderPhotoCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo1ImgLeadMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo2ImgLeadMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo4ImgLeadMargin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photo3_leading;

@property (weak, nonatomic) IBOutlet UIImageView *photo_pic1ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic2ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo1_alert;
@property (weak, nonatomic) IBOutlet UIImageView *photo2_alert;
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic4ImgView;
@property (weak, nonatomic) IBOutlet UIImageView *photo4_alert;


@property (weak, nonatomic) IBOutlet UILabel *vipTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photo_pic3ImgView;
@property (weak, nonatomic) IBOutlet UIButton *photo3_button;
@property (weak, nonatomic) IBOutlet UIImageView *photo3_alert;

@property (strong,nonatomic) NSURL* equip_pic1;
@property (strong,nonatomic) NSURL* equip_pic2;
@property (strong,nonatomic) NSURL* vip_pic;
@property (strong,nonatomic) NSURL* equip_pic4;




@end

@implementation XYRepairOrderPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.photo1ImgLeadMargin.constant = self.photo2ImgLeadMargin.constant = self.photo4ImgLeadMargin.constant = self.photo3_leading.constant = (SCREEN_WIDTH - 3 * 90)/4.0;
    //默认不展示红点
    self.photo1_alert.hidden = self.photo2_alert.hidden = self.photo3_alert.hidden =true;
    //默认不是vip
    self.vipTitleLabel.hidden = self.photo_pic3ImgView.hidden = self.photo3_button.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYRepairOrderPhotoCell";
}

+ (CGFloat)getHeightByVIP:(BOOL)isVip{
    return isVip?320:180;
}

- (void)setEquip_pic1:(NSURL *)equip_pic1{
    _equip_pic1 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic1.absoluteString]];
    [self.photo_pic1ImgView yy_setImageWithURL:_equip_pic1 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setEquip_pic2:(NSURL *)equip_pic2{
    _equip_pic2 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic2.absoluteString]];
    [self.photo_pic2ImgView yy_setImageWithURL:_equip_pic2 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

-(void)setEquip_pic4:(NSURL *)equip_pic4 {
    _equip_pic4 = [NSURL URLWithString:[XYStringUtil urlTohttps:equip_pic4.absoluteString]];
    [self.photo_pic4ImgView yy_setImageWithURL:_equip_pic4 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setVip_pic:(NSURL *)vip_pic{
    _vip_pic = [NSURL URLWithString:[XYStringUtil urlTohttps:vip_pic.absoluteString]];
    [self.photo_pic3ImgView yy_setImageWithURL:vip_pic placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (IBAction)equip_pic1Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic1 absoluteString]]){
        [self showBigImage:self.equip_pic1 name:xy_photo_cell_devno_pic1];
    }else{
        if (self.photo1_alert.hidden) {
            if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
                [self.delegate takePictureWithName:xy_photo_cell_devno_pic1];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(uploadPicture:name:)]) {
                [self.delegate uploadPicture:self.photo_pic1ImgView.image name:xy_photo_cell_devno_pic1];
            }
        }
    }
}

- (IBAction)equip_pic2Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic2 absoluteString]]){
        [self showBigImage:self.equip_pic2 name:xy_photo_cell_devno_pic2];
    }else{
        if (self.photo2_alert.hidden) {
            if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
                [self.delegate takePictureWithName:xy_photo_cell_devno_pic2];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(uploadPicture:name:)]) {
                [self.delegate uploadPicture:self.photo_pic2ImgView.image name:xy_photo_cell_devno_pic2];
            }
        }
    }
}

- (IBAction)equip_pic4Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic4 absoluteString]]){
        [self showBigImage:self.equip_pic4 name:xy_photo_cell_devno_pic4];
    }else{
        if (self.photo4_alert.hidden) {
            if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
                [self.delegate takePictureWithName:xy_photo_cell_devno_pic4];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(uploadPicture:name:)]) {
                [self.delegate uploadPicture:self.photo_pic4ImgView.image name:xy_photo_cell_devno_pic4];
            }
        }
    }

}

- (IBAction)equip_pic3Clicked:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    if(![XYStringUtil isNullOrEmpty:[self.vip_pic absoluteString]]){
        [self showBigImage:self.vip_pic name:xy_photo_cell_devno_pic3];
    }else{
        if (self.photo3_alert.hidden) {
            if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
                [self.delegate takePictureWithName:xy_photo_cell_devno_pic3];
            }
        }else{
            if ([self.delegate respondsToSelector:@selector(uploadPicture:name:)]) {
                [self.delegate uploadPicture:self.photo_pic3ImgView.image name:xy_photo_cell_devno_pic3];
            }
        }
    }
}

- (void)showBigImage:(NSURL*)imgUrl name:(NSString*)picName{
    [XYPhotoBigImageView showBigImageWithUrl:imgUrl name:picName canRetake:self.canRetakePhoto delegate:self];
}

- (void)retakePicture:(NSString *)picName{
    if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
        [self.delegate takePictureWithName:picName];
    }
}

- (void)setVip:(BOOL)isVip{
    self.vipTitleLabel.hidden = self.photo_pic3ImgView.hidden = self.photo3_button.hidden = !isVip;
    if(!isVip){
        self.photo3_alert.hidden = true;
    }
}

- (void)setUrl:(NSString*)url localImage:(UIImage*)img forName:(NSString*)name{
    
    //有url 则展示url图片
    if (![XYStringUtil isNullOrEmpty:url]) {
        if ([name isEqualToString:xy_photo_cell_devno_pic1])
        {
            self.equip_pic1 = [NSURL URLWithString:url];
            self.photo1_alert.hidden = true;
        }
        else if ([name isEqualToString:xy_photo_cell_devno_pic2])
        {
            self.equip_pic2 = [NSURL URLWithString:url];
            self.photo2_alert.hidden = true;
        }
        else if ([name isEqualToString:xy_photo_cell_devno_pic3]){
            self.vip_pic = [NSURL URLWithString:url];
            self.photo3_alert.hidden = true;
        }
        else if ([name isEqualToString:xy_photo_cell_devno_pic4])
        {
            self.equip_pic4 = [NSURL URLWithString:url];
            self.photo4_alert.hidden = true;
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
    else if ([name isEqualToString:xy_photo_cell_devno_pic3]){
        self.photo_pic3ImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo3_alert.hidden = (!img);
    }
    else if ([name isEqualToString:xy_photo_cell_devno_pic4])
    {
        self.photo_pic4ImgView.image = img?img:[UIImage imageNamed:xy_photo_placeholder];
        self.photo4_alert.hidden = (!img);
    }
}


@end
