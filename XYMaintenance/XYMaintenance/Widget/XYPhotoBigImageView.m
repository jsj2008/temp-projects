//
//  XYPhotoBigImageView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/6/23.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPhotoBigImageView.h"
#import "Masonry.h"
#import "UIImageView+YYWebImage.h"

@implementation XYPhotoBigImageView

+ (void)showBigImageWithUrl:(NSURL*)imgUrl name:(NSString*)picName canRetake:(BOOL)canRetake  delegate:(id<XYPhotoBigImageViewDelegate>)delegate{
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    XYPhotoBigImageView* imgView = [[XYPhotoBigImageView alloc]initWithFrame:window.bounds];
    imgView.backgroundColor = [UIColor blackColor];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.userInteractionEnabled = true;
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:imgView action:@selector(hidePhotoBigImageView)];
    [imgView addGestureRecognizer:tapGesture];
    [imgView.retakeButton addTarget:imgView action:@selector(retakePicture) forControlEvents:UIControlEventTouchUpInside];
    [window addSubview:imgView];
    
    [imgView.imageView yy_setImageWithURL:imgUrl placeholder:[UIImage imageNamed:@"bg_cancel"]];
    imgView.picName = picName;
    imgView.delegate = delegate;
    imgView.retakeButton.hidden = !canRetake;
}

- (void)hidePhotoBigImageView{
    [self removeFromSuperview];
}

- (void)retakePicture{
    if ([self.delegate respondsToSelector:@selector(retakePicture:)]) {
        [self.delegate retakePicture:self.picName];
    }
    [self hidePhotoBigImageView];
}

- (UIImageView*)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self);
        }];
    }
    return _imageView;
}

- (UIButton*)retakeButton{
    if (!_retakeButton) {
        _retakeButton = [[UIButton alloc]init];
        [_retakeButton setTitle:@"  重拍  " forState:UIControlStateNormal];
        _retakeButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_retakeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _retakeButton.backgroundColor = [UIColor blackColor];
        [self insertSubview:_retakeButton aboveSubview:self.imageView];
        [_retakeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self).offset(-20);
        }];
    }
    return _retakeButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
