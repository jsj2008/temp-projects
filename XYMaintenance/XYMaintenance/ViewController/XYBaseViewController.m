//
//  BaseViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "XYAPPSingleton.h"

@interface XYBaseViewController ()<UIGestureRecognizerDelegate>

@end

@implementation XYBaseViewController

- (id)init{
    if (self = [super init]) {
        [self registerForNotifications];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //UI通用配置
    [self doUIGeneralConfigurations];
    
    //子类实现的方法
    [self initializeModelBinding];
    [self initializeData];
    [self initializeUIElements];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[XYAPPSingleton sharedInstance] setWaterMarkHidden:false];//默认显示所有水印
}


#pragma mark - initializations

- (void)initializeModelBinding
{
    TTDEBUGLOG(@"To Be Implemented By Subclasses %s",__func__);
}

- (void)registerForNotifications
{
   TTDEBUGLOG(@"To Be Implemented By Subclasses %s",__func__);
}

- (void)initializeData
{
  TTDEBUGLOG(@"To Be Implemented By Subclasses %s",__func__);
}

- (void)initializeUIElements
{
  TTDEBUGLOG(@"To Be Implemented By Subclasses %s",__func__);
}


#pragma mark - configurations

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)doUIGeneralConfigurations{
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = WHITE_COLOR;
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark - note styles on view

-(void)showLoadingMask{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"加载中...";
}

-(void)hideLoadingMask{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)showToast:(NSString*)toast{
    if (toast && toast.length>0)[self.view makeToast:toast duration:2.0 position:CSToastPositionCenter];
}

#pragma mark - go back

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (void)shouldShowBackButton:(BOOL)isShown{
    if (isShown){
        //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_back"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
    }else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

- (void)goBack{
    if ([self.navigationController.viewControllers count]>1) {
        [self.navigationController popViewControllerAnimated:true];
    }
}

- (void)switchToGestureBackMode:(BOOL)canSwipeBack
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = canSwipeBack;
    }
    
    __weak typeof (self) weakSelf = self;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]){
        self.navigationController.interactivePopGestureRecognizer.delegate = canSwipeBack ? weakSelf : nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - life cycle others

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // [MobClick beginLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
   // [MobClick endLogPageView:[NSString stringWithFormat:@"%@",[self class]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    TTDEBUGLOG(@"DEALLOC: %@", [self class]);
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
