//
//  XYNoticeDetailViewController.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYNoticeDetailViewController.h"
#import "XYAPIService+V5API.h"

@interface XYNoticeDetailViewController ()<UIWebViewDelegate>
@property(strong,nonatomic)UIWebView* webView;
@end

@implementation XYNoticeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* link = [XYStringUtil urlTohttps:self.linkUrl];
    NSURLRequest* request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:link]];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - initialize

- (void)initializeUIElements{
    
    self.navigationItem.title = @"公告详情";
    //内嵌页
    self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.equalTo(self.view);
    }];
}

#pragma mark - delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    self.navigationItem.title = @"加载中...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.navigationItem.title = @"公告详情";
    //记录日志
    [self logReading];
    //注入阅读数
    NSString* jsStr = [NSString stringWithFormat:@"var header = document.body.getElementsByTagName('header')[0];var p = document.createElement(\"time\");p.style.padding = '20px'; p.innerText = \"%@人已读\"; header.appendChild(p);",@(self.view_count)];
    [self.webView stringByEvaluatingJavaScriptFromString:jsStr];
}

#pragma mark - action

- (void)logReading{
   [[XYAPIService shareInstance]logNoticeReading:self.noticeId success:^{
       TTDEBUGLOG(@"记录成功");
   } errorString:^(NSString *err) {
       TTDEBUGLOG(@"记录失败:%@",err);
   }];
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
