//
//  XYUserHeaderView.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYUserHeaderView.h"
#import "XYConfig.h"
#import "XYStringUtil.h"
#import "UIImageView+YYWebImage.h"
#import "XYWidgetUtil.h"

@interface XYUserHeaderView ()

@property (retain,nonatomic) UIImageView* avatarImageView;
@property (retain,nonatomic) UILabel* nameLabel;
@property (retain,nonatomic) UILabel* workerIdLabel;
@property (retain,nonatomic) UILabel* phoneLabel;

@end

@implementation XYUserHeaderView

- (instancetype)init{
    if (self = [super init]){
        [self setUpUIElements];
    }
    return self;
}

- (void)setUpUIElements{
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 94);
    
    self.avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 64, 64)];
    self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width/2;
    self.avatarImageView.layer.masksToBounds = true;
    [self addSubview:self.avatarImageView];
    
    self.infoButton = [[UIButton alloc]initWithFrame:self.avatarImageView.frame];
    [self addSubview:self.infoButton];
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 15, 31, SCREEN_WIDTH - (self.avatarImageView.frame.origin.x + self.avatarImageView.frame.size.width + 15) - 20, 15)];
    self.nameLabel.textColor = BLACK_COLOR;
    self.nameLabel.adjustsFontSizeToFitWidth = true;
    self.nameLabel.font = SIMPLE_TEXT_FONT;
    [self addSubview:self.nameLabel];
    
    self.workerIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 10, self.nameLabel.frame.size.width, 15)];
    self.workerIdLabel.adjustsFontSizeToFitWidth = true;
    self.workerIdLabel.textColor = BLACK_COLOR;
    self.workerIdLabel.font = SIMPLE_TEXT_FONT;
    [self addSubview:self.workerIdLabel];
}

- (void)setUserInfo:(XYUserDto*)user{
    
    if (!user){
        return;
    }
    
    [self setImageUrl:user.Url];
    self.nameLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"姓名：%@",user.realName] lightRange:@"姓名：" lightColor:LIGHT_TEXT_COLOR];
    self.workerIdLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"工号：%@",user.Name] lightRange:@"工号：" lightColor:LIGHT_TEXT_COLOR];
    self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@",user.mobile];
}

- (void)setImageUrl:(NSString*)imageUrl{
    
    NSString* imgUrl = [XYStringUtil urlTohttps:imageUrl];

    [self.avatarImageView yy_setImageWithURL:[NSURL URLWithString:imgUrl] placeholder:[UIImage imageNamed:@"img_avatar"] options:YYWebImageOptionHandleCookies progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
        //压缩图片
        NSData* compressData = [XYWidgetUtil resetSizeOfImageData:image maxSize:100];
        TTDEBUGLOG(@"compress data: %@ K",@(compressData.length/1024.0));
        return [UIImage imageWithData:compressData];
    } completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
