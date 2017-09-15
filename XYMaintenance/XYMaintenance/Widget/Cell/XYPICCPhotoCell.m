//
//  XYPICCPhotoCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPICCPhotoCell.h"
#import "XYConfig.h"
#import "UIImageView+YYWebImage.h"
#import "XYStringUtil.h"

static NSString *xy_photo_placeholder = @"photo_add";


@interface XYPICCPhotoCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equip1_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *equip2_trailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card1_leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *card2_trailing;
@end

@implementation XYPICCPhotoCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.equip1_leading.constant = self.equip2_trailing.constant = (SCREEN_WIDTH - 2 * 90)/3.0;
    self.card1_leading.constant = self.card2_trailing.constant = (SCREEN_WIDTH - 2 * 90)/3.0;
    self.idcard_alert1.hidden = self.idcard_alert2.hidden = self.equip_alert1.hidden = self.equip_alert2.hidden = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYPICCPhotoCell";
}

+ (CGFloat)defaultHeight{
   return 325;
}

- (void)setEquip_pic1:(NSURL *)equip_pic1{
    _equip_pic1 = equip_pic1;
    [self.equip_pic1ImgView yy_setImageWithURL:equip_pic1 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setEquip_pic2:(NSURL *)equip_pic2{
    _equip_pic2 = equip_pic2;
    [self.equip_pic2ImgView yy_setImageWithURL:equip_pic2 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setIdcard_pic1:(NSURL *)idcard_pic1{
    _idcard_pic1 = idcard_pic1;
    [self.idcard_pic1ImgView yy_setImageWithURL:idcard_pic1 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}

- (void)setIdcard_pic2:(NSURL *)idcard_pic2{
    _idcard_pic2 = idcard_pic2;
    [self.idcard_pic2ImgView yy_setImageWithURL:idcard_pic2 placeholder:[UIImage imageNamed:xy_photo_placeholder]];
}


- (IBAction)equip_pic1Clicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic1 absoluteString]]){
        [self showBigImage:self.equip_pic1 name:xy_photo_cell_equip_pic1];
    }else{
        if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
            [self.delegate takePictureWithName:xy_photo_cell_equip_pic1];
        }
    }
}

- (IBAction)equip_pic2Clicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    
    if(![XYStringUtil isNullOrEmpty:[self.equip_pic2 absoluteString]]){
        [self showBigImage:self.equip_pic2 name:xy_photo_cell_equip_pic2];
    }else{
        if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
            [self.delegate takePictureWithName:xy_photo_cell_equip_pic2];
        }
    }
}

- (IBAction)idcard_pic1Clicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    
    if(![XYStringUtil isNullOrEmpty:[self.idcard_pic1 absoluteString]]){
        [self showBigImage:self.idcard_pic1 name:xy_photo_cell_idcard_pic1];
    }else{
        if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
            [self.delegate takePictureWithName:xy_photo_cell_idcard_pic1];
        }
    }
}

- (IBAction)idcard_pic2Clicked:(id)sender {
    
    [[UIApplication sharedApplication].keyWindow endEditing:false];
    
    if(![XYStringUtil isNullOrEmpty:[self.idcard_pic2 absoluteString]]){
        [self showBigImage:self.idcard_pic2 name:xy_photo_cell_idcard_pic2];
    }else{
        if ([self.delegate respondsToSelector:@selector(takePictureWithName:)]) {
            [self.delegate takePictureWithName:xy_photo_cell_idcard_pic2];
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

- (void)setUrl:(NSString*)urlStr forName:(NSString*)name{
    
    NSURL* url = [NSURL URLWithString:urlStr];
    
    if ([name isEqualToString:xy_photo_cell_equip_pic1]) {
        self.equip_pic1 = url;
        self.equip_alert1.hidden = true;
    }else if ([name isEqualToString:xy_photo_cell_equip_pic2]) {
        self.equip_pic2 = url;
        self.equip_alert2.hidden = true;
    }else if ([name isEqualToString:xy_photo_cell_idcard_pic1]) {
        self.idcard_pic1 = url;
        self.idcard_alert1.hidden = true;
    }else if ([name isEqualToString:xy_photo_cell_idcard_pic2]) {
        self.idcard_pic2 = url;
        self.idcard_alert2.hidden = true;
    }
    
    return;
}

@end




//- (void)setLocalImage:(UIImage*)img forName:(NSString*)name{
//    
//    if (!img) {
//        return;
//    }
//    
//    if ([name isEqualToString:xy_photo_cell_equip_pic1]) {
//        self.equip_pic1ImgView.image= img;
//        self.equip_alert1.hidden = false;
//    }else if ([name isEqualToString:xy_photo_cell_equip_pic2]) {
//        self.equip_pic2ImgView.image= img;
//        self.equip_alert2.hidden = false;
//    }else if ([name isEqualToString:xy_photo_cell_idcard_pic1]) {
//        self.idcard_pic1ImgView.image= img;
//        self.idcard_alert1.hidden = false;
//    }else if ([name isEqualToString:xy_photo_cell_idcard_pic2]) {
//        self.idcard_pic2ImgView.image= img;
//        self.idcard_alert2.hidden = false;
//    }
//    return;
//}



