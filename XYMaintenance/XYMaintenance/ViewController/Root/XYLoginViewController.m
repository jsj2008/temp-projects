//
//  LoginViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/15.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYLoginViewController.h"
#import "XYLoginViewModel.h"
#import "XYSimpleTextField.h"
#import "XYCountDownButton.h"
#import "XYServiceProtocolView.h"

@interface XYLoginViewController ()<XYLoginCallBackDelegate,UITextFieldDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet XYSimpleTextField *accountTextField;
@property (weak, nonatomic) IBOutlet XYSimpleTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet XYSimpleTextField *codeTextField;
@property (weak, nonatomic) IBOutlet XYCountDownButton *codeButton;
@property (weak, nonatomic) IBOutlet UILabel *noticeLabel;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight3;

@property (strong, nonatomic) XYLoginViewModel* viewModel;

@end

@implementation XYLoginViewController

#pragma mark - life cycle

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    self.viewModel.delegate = nil;
    [self.viewModel cancelAllRequests];
}

#pragma mark - overrides

- (void)initializeModelBinding{
    self.viewModel = [[XYLoginViewModel alloc]init];
    self.viewModel.delegate = self;
}

- (void)initializeUIElements{
    
    self.navigationItem.title = @"登录";
    [self shouldShowBackButton:false];
    
    self.backgroundView.backgroundColor = THEME_COLOR;
    self.noticeLabel.textColor = THEME_COLOR;
    [self.accountTextField setLeftImage:[UIImage imageNamed:@"login_account"]];
    [self.passwordTextField setLeftImage:[UIImage imageNamed:@"login_pwd"]];
    [self.codeTextField setLeftImage:[UIImage imageNamed:@"login_code"]];
    
    self.accountTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.accountTextField.text = self.viewModel.preAccount;
    self.passwordTextField.text = self.viewModel.prePassword;
    
    self.deviderHeight1.constant = self.deviderHeight2.constant = self.deviderHeight3.constant = LINE_HEIGHT;
}

#pragma mark - private methods

- (IBAction)doLogin:(id)sender{
    
    if (![XYStringUtil isAccountID:self.accountTextField.text]){
        [self showNotice:TT_WRONG_ACCOUNT];
        return;
    }
    
    if (![XYStringUtil isPassword:self.passwordTextField.text]){
        [self showNotice:TT_WRONG_PWD];
        return;
    }
    
    if ([XYStringUtil isNullOrEmpty:self.codeTextField.text]){
        [self showNotice:TT_WRONG_CODE];
        return;
    }
    
    [self resetNotice];
    [self showLoadingMask];
    [[XYAPIService shareInstance]getAgreementConfirmingStatus:self.accountTextField.text success:^(XYAgreementDto *agreement) {
        if (agreement.agreement) {//已经同意过，直接走人
           [self.viewModel doLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text code:self.codeTextField.text];
        }else{
           [self showProtocolWithUrl:[NSURL URLWithString:agreement.url] type:agreement.bid shouldLogin:true];
        }
    } errorString:^(NSString *error) {
        [self hideLoadingMask];
        [self showToast:error];
    }];
    
    
}

#pragma mark - call service phone 

- (IBAction)onCannotLogin:(id)sender {
    [XYAlertTool callPhone:SERVICE_PHONE onView:self];
}

- (IBAction)showProtocol:(id)sender {
    
    if (![XYStringUtil isAccountID:self.accountTextField.text]){
        [self showNotice:TT_WRONG_ACCOUNT];
        return;
    }
    
    [self showLoadingMask];
    [[XYAPIService shareInstance]getAgreementConfirmingStatus:self.accountTextField.text success:^(XYAgreementDto *agreement) {
        [self hideLoadingMask];
        [self showProtocolWithUrl:[NSURL URLWithString:agreement.url] type:agreement.bid shouldLogin:false];
    } errorString:^(NSString *error) {
        [self hideLoadingMask];
        [self showToast:error];
    }];
}

- (void)showProtocolWithUrl:(NSURL*)url type:(XYBrandType)bid shouldLogin:(BOOL)shouldLogin{
    //收起键盘
    [self.view endEditing:true];
    //展示协议弹窗
    XYServiceProtocolView* protocolView = [XYServiceProtocolView protocolViewWithUrl:url];
    __weak typeof(protocolView) weakView = protocolView;
    [protocolView setButtonsDidClick:^{
        [weakView dismiss];
        [[XYAPIService shareInstance]confirmAgreement:self.accountTextField.text type:bid success:^{
            if (shouldLogin) {
                [self.viewModel doLoginWithAccount:self.accountTextField.text password:self.passwordTextField.text code:self.codeTextField.text];
            }
        } errorString:^(NSString *error) {
            [self hideLoadingMask];
            [self showToast:error];
        }];
    
    }];
    [protocolView show];
}

#pragma mark - handle error notice

- (void)showNotice:(NSString*)str{
    self.noticeLabel.text = str;
}

- (void)resetNotice{
    [self showNotice:@""];
}

- (IBAction)getVerifyCode:(id)sender {
    
    if (![XYStringUtil isAccountID:self.accountTextField.text]){
        [self showNotice:TT_WRONG_ACCOUNT];
        return;
    }
    
    [self.codeButton startCountDown];
    [self.viewModel getVerifyCode:self.accountTextField.text];
}

#pragma mark - viewModel callback

- (void)onVerifyCodeSent:(BOOL)success note:(NSString *)note{
    if (success) {
       [self showToast:@"验证码发送成功，请查看手机短信！"];
    }else{
       [self.codeButton reset];
       [self showToast:note];
    }
}

- (void)onLoginResult:(BOOL)success note:(NSString*)note{
   [self hideLoadingMask];
    if(success){
        [self.codeButton reset];
        self.codeTextField.text = @"";
        [self.navigationController popViewControllerAnimated:false];
        [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_LOGIN object:nil];
    }else{
        [self showNotice:note];
    }
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
