//
//  XYQRCodeCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYQRCodeCell.h"
#import "XYConfig.h"
#import "XYStrings.h"
#import "UIButton+YYWebImage.h"
#import "XYOrderListManager.h"
#import "XYStringUtil.h"

#define XYQRCodeCellButtonWidth 150

@implementation XYQRCodeCell

//重定向 备用
//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString *urlstr = request.URL.absoluteString;
//    NSRange range = [urlstr rangeOfString:@"ios://jwzhangjie"];
//    if (range.length!=0) {
//        _js_call_oc_show.text = [NSString stringWithFormat:@"请访问地址：%@", urlstr];
//    }
//    return YES;
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self resetQRCodes];
    [self.wechatBtn setTitle:TT_LOADING forState:UIControlStateDisabled];
    [self.alipayBtn setTitle:TT_LOADING forState:UIControlStateDisabled];
    self.wechatBtn.layer.borderColor = DEVIDE_LINE_COLOR.CGColor;
    self.wechatBtn.layer.borderWidth = LINE_HEIGHT;
    self.wechatBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.alipayBtn.layer.borderColor = DEVIDE_LINE_COLOR.CGColor;
    self.alipayBtn.layer.borderWidth = LINE_HEIGHT;
    self.alipayBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.scrollView.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (IBAction)getWechatCode:(id)sender {
    [self.wechatBtn setBackgroundImage:nil forState:UIControlStateDisabled];
    self.wechatBtn.enabled = false;
    [self.codeDelegate getQrCodeOfType:XYQRCodeCellTypeWechat];
}

- (IBAction)getAlipayCode:(id)sender {
    [self.alipayBtn setBackgroundImage:nil forState:UIControlStateDisabled];
    self.alipayBtn.enabled  = false;
    [self.codeDelegate getQrCodeOfType:XYQRCodeCellTypeAlipay];
}

- (void)setQRCode:(NSString*)code price:(NSString*)price type:(XYQRCodePayType)type bid:(XYBrandType)bid success:(BOOL)isSuccess{
    _bid = bid;
    if (isSuccess) {
        NSString* imgUrl = [XYStringUtil urlTohttps:code];
        switch (type) {
            case XYQRCodeCellTypeWechat:{
                [self.wechatBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&price=%@",imgUrl,price]] forState:UIControlStateDisabled placeholder:nil options:YYWebImageOptionHandleCookies completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    //图片请求带上cookie
                    [self.wechatBtn setTitle:@"" forState:UIControlStateNormal];
                    [self.wechatBtn setBackgroundImage:image forState:UIControlStateNormal];
                    self.wechatBtn.enabled = true;
                }];
            }
                break;
            case XYQRCodeCellTypeAlipay:{
                [self.alipayBtn yy_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@&price=%@",imgUrl,price]] forState:UIControlStateDisabled placeholder:nil options:YYWebImageOptionHandleCookies completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                    [self.alipayBtn setTitle:@"" forState:UIControlStateNormal];
                    [self.alipayBtn setBackgroundImage:image forState:UIControlStateNormal];
                    self.alipayBtn.enabled = true;
                }];
            }
                break;
            default:
                break;
        }
    }else{
        self.wechatBtn.enabled = true;
        self.alipayBtn.enabled = true;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x > 0 && self.alipayBtn.enabled) {
        self.alipayBtn.enabled  = false;
        [self.codeDelegate getQrCodeOfType:XYQRCodeCellTypeAlipay];
    }
}

- (void)resetQRCodes{
    [self resetQRCode:XYQRCodeCellTypeWechat];
    [self resetQRCode:XYQRCodeCellTypeAlipay];
}

- (void)resetQRCode:(XYQRCodePayType)type{
    switch (type) {
        case XYQRCodeCellTypeWechat:
        {
            self.wechatBtn.userInteractionEnabled = true;
            [self.wechatBtn setTitle:@"点击获取微信付款码" forState:UIControlStateNormal];
            [self.wechatBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }
            break;
        case XYQRCodeCellTypeAlipay:
        {
            self.alipayBtn.userInteractionEnabled = true;
            [self.alipayBtn setTitle:@"点击获取支付宝付款码" forState:UIControlStateNormal];
            [self.alipayBtn setBackgroundImage:nil forState:UIControlStateNormal];
        }
        default:
            break;
    }
}

#pragma mark - 屏蔽逻辑

- (NSInteger)startPageIndex{
    XYPayOpenModel* model = [[XYOrderListManager sharedInstance].payOpenMap objectForKey:[NSString stringWithFormat:@"%@",@(self.bid)]];
    //默认展示按钮
    if (model.qrcode) {
        return XYQRCodeCellTypeWechat;//微信支付
    }else if(model.qrcodealipay){
        return XYQRCodeCellTypeAlipay;//支付宝
    }else{
        return XYQRCodeCellTypeUnknown;
    }
}

- (NSInteger)numberOfButtons{
    NSInteger num = 0;
    XYPayOpenModel* model = [[XYOrderListManager sharedInstance].payOpenMap objectForKey:[NSString stringWithFormat:@"%@",@(self.bid)]];
    if (model.qrcode) {
        num+=1;//微信支付
    }
    if (model.qrcodealipay) {
        num+=1;//支付宝支付
    }
    return num;
}

- (void)initAndAutoLoadQrCode:(XYBrandType)bid delegate:(id<XYQRCodeCellDelegate>)delegate{
    self.codeDelegate = delegate;
    self.bid = bid;
    //按钮隐藏显示逻辑
    NSInteger numberOfButtons = [self numberOfButtons];
    self.titleLabel.hidden = self.scrollView.hidden = (numberOfButtons==0);
    self.scrollView.scrollEnabled = (numberOfButtons>1);
    self.scrollView.contentOffset = CGPointMake([self startPageIndex]*XYQRCodeCellButtonWidth,0);
    //默认自动加载二维码
    NSInteger startPage = [self startPageIndex];
    if (startPage == XYQRCodeCellTypeWechat) {
        self.wechatBtn.enabled = false;
        [self.codeDelegate getQrCodeOfType:XYQRCodeCellTypeWechat];
    }else if (startPage == XYQRCodeCellTypeAlipay) {
        self.alipayBtn.enabled = false;
        [self.codeDelegate getQrCodeOfType:XYQRCodeCellTypeAlipay];
    }else{
        //do nothing
    }
}

+ (CGFloat)defaultHeight{
    return 238;
}

+ (NSString*)defaultReuseId{
   return @"XYQRCodeCell";
}

@end
