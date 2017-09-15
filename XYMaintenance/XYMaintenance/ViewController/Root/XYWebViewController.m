//
//  XYWebViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYWebViewController.h"

@interface XYWebViewController ()<UIWebViewDelegate>
{
    UIWebView* _webView;
    NSURL *_toLoadURL;
}
@end

@implementation XYWebViewController

- (id)initWithNSUrl:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        _toLoadURL = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override

- (void)initializeUIElements
{
    self.navigationItem.title = @"加载中...";
    [self shouldShowBackButton:true];
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.bounds.size.height)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:_toLoadURL];
    [_webView loadRequest:request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString* title = [webView stringByEvaluatingJavaScriptFromString: @"document.title"];
    self.title = title;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
