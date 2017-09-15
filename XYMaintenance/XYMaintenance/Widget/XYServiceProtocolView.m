//
//  XYServiceProtocolView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/10.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYServiceProtocolView.h"
#import "XYCustomButton.h"
#import "XYStringUtil.h"

static NSInteger XYServiceProtocolViewCountDownSeconds = 6;
static NSString* XYServiceProtocolViewButtonTitle = @"同意协议";

@interface XYServiceProtocolView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet XYCustomButton *confirmButton;
@property (strong,nonatomic) NSTimer* countDownTimer;
@property (assign,nonatomic) NSInteger countDown;
@property (assign,nonatomic) BOOL linkLoaded;
@property (assign,nonatomic) BOOL isWeb;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *height;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation XYServiceProtocolView
+ (XYServiceProtocolView*)protocolViewWithNotice:(NSString*)notice{
    XYServiceProtocolView* protocolView = [[XYServiceProtocolView alloc]init];
    protocolView.notice = notice;
    protocolView.title = @"第三方平台评价提醒";
    protocolView.submitTitle = @"我知道了";
    protocolView.isWeb = false;
    return protocolView;
}

+ (XYServiceProtocolView*)protocolViewWithUrl:(NSURL*)link{
    XYServiceProtocolView* protocolView = [[XYServiceProtocolView alloc]init];
    protocolView.linkUrl = link;
    protocolView.title = @"工程师服务条款";
    protocolView.submitTitle = @"同意协议";
    protocolView.isWeb = true;
    return protocolView;
}

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYServiceProtocolView" owner:self options:nil] objectAtIndex:0];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
    self.webView.delegate = self;
    self.webView.scrollView.showsVerticalScrollIndicator = true;
    [self.confirmButton setButtonEnable:false];
    self.linkLoaded = false;
    
    return self;
}

#pragma mark - delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    if (self.linkLoaded) {
        return;
    }
    
    self.linkLoaded = true;
    [self startCountDown];  //加载完毕，开始计时
}


#pragma mark - webView

- (void)startLoading{  
    [self disableButton];
    NSString* link = [XYStringUtil urlTohttps:self.linkUrl.absoluteString];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:link]];
    [self.webView loadRequest:request];
}

#pragma mark - button

- (void)disableButton{
    self.countDown = XYServiceProtocolViewCountDownSeconds;
    if (self.countDownTimer){
        [self.countDownTimer invalidate];
    }
    [self.confirmButton setButtonEnable:false];
    [self.confirmButton setTitle:self.submitTitle forState:UIControlStateDisabled];
}

- (void)startCountDown{
   self.countDown = XYServiceProtocolViewCountDownSeconds;
   [self.confirmButton setButtonEnable:false];
   self.countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}

- (void)timeFireMethod{
    self.countDown--;
    if (self.countDown <= 0){
        self.countDown = XYServiceProtocolViewCountDownSeconds;
        if (self.countDownTimer){
            [self.countDownTimer invalidate];
        }
        [self.confirmButton setButtonEnable:true];
        [self.confirmButton setTitle:self.submitTitle forState:UIControlStateNormal];
    }else{
        [self.confirmButton setTitle:[NSString stringWithFormat:@"%@s", @(self.countDown)] forState:UIControlStateDisabled];
    }
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (self.buttonsDidClick) {
        self.buttonsDidClick();
    }
}

#pragma mark - public

- (void)show{
    self.frame = [UIApplication sharedApplication].keyWindow.bounds;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    if (self.isWeb) {
        self.webView.hidden = NO;
        self.height.constant = 340;
        self.titleLabel.text = @"工程师服务条款";
        if (!self.linkLoaded) {
            [self startLoading];
        }
    
    }else {
        self.webView.hidden = YES;
        self.height.constant = 180;
        self.titleLabel.text = @"第三方平台评价提醒";
        self.noticeLabel.text = self.notice;
        [self startCountDown];
    }
}

- (void)dismiss{
    [self removeFromSuperview];
}


@end
