//
//  XYCountDownButton.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCountDownButton.h"
#import "XYConfig.h"

static NSString* TT_GET_VERIFY_CODE = @"发送验证码";

@interface XYCountDownButton ()
@property(strong,nonatomic)NSTimer* countDownTimer;
@property(assign,nonatomic)NSInteger countDown;
@end


@implementation XYCountDownButton

- (id)init {
    if (self = [super init]) {
        [self setUpView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setUpView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setUpView];
    }
    return self;
}

- (void)setUpView{
    [self setTitle:TT_GET_VERIFY_CODE forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:THEME_COLOR forState:UIControlStateNormal];
    [self setTitleColor:MOST_LIGHT_COLOR forState:UIControlStateDisabled];
    self.titleLabel.adjustsFontSizeToFitWidth = true;
}

- (void)startCountDown{
    self.countDown = 60;
    [self setTitle:[NSString stringWithFormat:@"%@s后重新获取", @(self.countDown)] forState:UIControlStateDisabled];
    self.enabled = false;
    self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

- (void)timeFireMethod{
    
    self.countDown--;
    
    if (self.countDown == 0){
        [self reset];
    }else{
        [self setTitle:[NSString stringWithFormat:@"%@s后重新获取", @(self.countDown)] forState:UIControlStateDisabled];
    }
}

- (void)reset{
    
    self.countDown = 60;
    if (self.countDownTimer){
        [self.countDownTimer invalidate];
    }
    
    self.enabled = true;
    [self setTitle:TT_GET_VERIFY_CODE forState:UIControlStateNormal];
}



@end
