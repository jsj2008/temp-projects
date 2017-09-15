//
//  XYRootViewController.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRootViewController.h"
#import "XYLoginViewController.h"
#import "XYOrderListViewController.h"
#import "XYPersonalCenterViewController.h"
#import "XYAPPSingleton.h"
#import "XYCacheHelper.h"
#import "XYOrderListManager.h"
#import "BaseNavigationController.h"
#import "XYOrderListMapViewController.h"
#import "XYAdminMainViewController.h"
#import "JPUSHService.h"
#import "XYNoticeListViewController.h"
#import "XYMyPartsViewController.h"
#import "XYAttendenceViewController.h"
#import "XYPromotionMainViewController.h"
#import "UITabBarItem+WZLBadge.h"
#import "XYServiceProtocolView.h"

typedef NS_ENUM(NSInteger, XYTabBarItemType) {
    XYTabBarItemTypeAdmin = 0,    //主页
    XYTabBarItemTypeOrder = 1,    //订单
    XYTabBarItemTypeMap = 2,      //地图
    XYTabBarItemTypeCenter = 3,   //个人中心
};


@interface XYRootViewController ()<UITabBarControllerDelegate>

//tabbar
@property(strong,nonatomic)UITabBarController* mainTabBarController;

//首页
@property(strong,nonatomic)XYAdminMainViewController* adminViewController;
@property(strong,nonatomic)XYBaseNavigationController* adminNavigationController;
//订单列表
@property(strong,nonatomic)XYOrderListViewController* orderListViewController;
@property(strong,nonatomic)XYBaseNavigationController* orderNavigationController;
//地图
@property(strong,nonatomic)XYOrderListMapViewController* mapViewController;
@property(strong,nonatomic)XYBaseNavigationController* mapNavigationController;
//个人中心
@property(strong,nonatomic)XYPersonalCenterViewController* personalCenterViewController;
@property(strong,nonatomic)XYBaseNavigationController* personalNavigationController;

//登录
@property(strong,nonatomic)XYLoginViewController* loginViewController;

@end

@implementation XYRootViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNewUserLogin) name:XY_NOTIFICATION_LOGIN object:nil];
    /**
     *  加载缓存用户信息和ticket
     */
    [[XYAPPSingleton sharedInstance] loadCachedData];
    
    /**
     *  进入主页
     */
    [self goToMainView];
    
    /**
     * 通知相关
     */
    [self processNotificationInfo];
    
    /**
     *  判断是否显示登陆页面、
     */
    if (![XYAPPSingleton sharedInstance].hasLogin){
        [self goToLogin];
    }else{
        //已登录 初始化支付方式可用性
        [self initFeatureAvailability];
         //已登录 绑定推送别名
        [self setAlias];
        //已登录 查询协议状态
        [self checkAgreementUpdate];
    }
}

- (void)setAlias{
    [JPUSHService setAlias:[XYAPPSingleton sharedInstance].currentUser.Name callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
}

- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    if (iResCode!=0) {
        TTDEBUGLOG(@"注册别名失败！%@",@(iResCode));
        [self performSelector:@selector(setAlias) withObject:nil afterDelay:5];
    }else{
        TTDEBUGLOG(@"注册别名成功！");
    }
}

- (void)initFeatureAvailability{
    
    //支付开关
    //当前逻辑：获取功能列表
    //如有该功能，取其状态
    //如果没有 取缓存
    //缓存也没有 默认功能guanbi =-=
    
    [[XYOrderListManager sharedInstance] loadPayStatusSwitchFromCache];
    [[XYOrderListManager sharedInstance] getPaymentAvailability];
}

- (void)checkAgreementUpdate{
    [[XYAPIService shareInstance]getAgreementConfirmingStatus:[XYAPPSingleton sharedInstance].currentUser.Name success:^(XYAgreementDto *agreement) {
        if (!agreement) {
            //如果没同意，弹框
            XYServiceProtocolView* protocolView = [XYServiceProtocolView protocolViewWithUrl:[NSURL URLWithString:agreement.url]];
            __weak typeof(protocolView) weakView = protocolView;
            [protocolView setButtonsDidClick:^{
                [weakView dismiss];
                [[XYAPIService shareInstance]confirmAgreement:[XYAPPSingleton sharedInstance].currentUser.Name type:agreement.bid success:^{
                } errorString:^(NSString *error) {
                }];
            }];
            [protocolView show];
        }
    } errorString:^(NSString *err) {}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - notification

- (void)onNewUserLogin{
    //更新tabbar
    [self updateTabBar];
    //所有navibar清除子控制器，只显示第一页
    [self.adminNavigationController popToRootViewControllerAnimated:false];
    [self.orderNavigationController popToRootViewControllerAnimated:false];
    [self.mapNavigationController popToRootViewControllerAnimated:false];
    [self.personalNavigationController popToRootViewControllerAnimated:false];
}

#pragma mark - override

- (void)initializeUIElements{
    [self.navigationController setNavigationBarHidden:true animated:false];
    [self shouldShowBackButton:false];
}

#pragma mark - 跳转逻辑

- (void)jumpToPageByType:(XYPushNotificationType)type{
    [self updateTabBar];
    //从后台来的 跳转页面
    switch (type) {
        case XYPushNotificationTypeNewNotice:
            [self goToNewsList];
            break;
        case XYPushNotificationTypeNewOrder:
            [self goToOrderMap];
            break;
        case XYPushNotificationTypeClaimParts:
            [self goToPartsList:YES];
            break;
        case XYPushNotificationTypeLeaveApproved:
            [self goToAttendanceView];
            break;
        default:
            [self goToOrderList];
            break;
    }
}

- (void)showMarkByType:(XYPushNotificationType)type{
    //根据type发送红点事件
    switch (type) {
        case XYPushNotificationTypeNewNotice:
            [self showRedPointOnNews];
            break;
        case XYPushNotificationTypeNewOrder:
            [self showRedPointOnMap];
            break;
        case XYPushNotificationTypeAssignOrder:
            [self showRedPointOnOrderList];
            break;
        case XYPushNotificationTypeClaimParts:
            [self showRedPointOnParts];
            break;
        case XYPushNotificationTypeLeaveApproved:
            [self showRedPointOnAttendance];
            break;
        default:
            break;
    }
}

- (void)goToMainView{
    //直接前往
    [self updateTabBar];
    [self.navigationController pushViewController:self.mainTabBarController animated:NO];
}

- (void)processNotificationInfo{
    //已登录，弹出通知相关页面
    switch (self.preNotificationType) {
        case XYPushNotificationTypeUnknown:
            break;
        case XYPushNotificationTypeNewNotice:
            //公告
            [self presentNewsListOnLaunch];
            break;
        case XYPushNotificationTypeNewOrder:
        {   //如果是从通知启动的，直接前往订单地图
            self.mapViewController.isFromTabSelection = true;
            if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeMap) {
                [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeMap];
            }
        }
            break;
        case XYPushNotificationTypeClaimParts:
        {
            [self presentPartsListOnLaunch];
            if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeCenter) {
                [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeCenter];
            }
        }
            break;
        case XYPushNotificationTypeLeaveApproved:
            [self presentAttendanceOnLaunch];
            break;
        default:
            [self goToOrderList];
            break;
    }
}

- (void)goToLogin{
    [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeAdmin];
    if (![self.navigationController.topViewController isKindOfClass:[XYLoginViewController class]]){
         [self.navigationController pushViewController:self.loginViewController animated:false];
    }
}

- (void)goToOrderList{
    if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeOrder){
        [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeOrder];
    }
    [self.orderListViewController showNewOrdersList];
}


- (void)goToNewsList{
    if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeAdmin){
        [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeAdmin];
    }
    [self.adminViewController showNewsList];
}

- (void)goToAttendanceView{
    if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeAdmin){
        [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeAdmin];
    }
    [self.adminViewController goToAttendanceView];
}

- (void)goToPartsList:(BOOL)isClaimPartsNotify{
    if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeCenter){
        [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeCenter];
    }
    [self.personalCenterViewController goToMyParts:isClaimPartsNotify];
}

- (void)goToOrderMap{
    if (self.mainTabBarController.viewControllers.count > XYTabBarItemTypeMap){
        [self.mainTabBarController setSelectedIndex:XYTabBarItemTypeMap];
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_MAPLIST object:nil];
}

- (void)showRedPointOnOrderList{
    //刷新未完成订单
    [[NSNotificationCenter defaultCenter]postNotificationName:XY_NOTIFICATION_REFRESH_NEW_ORDER object:nil];
    
    if ((!self.mainTabBarController) || self.mainTabBarController.selectedIndex == XYTabBarItemTypeOrder) {
        return;//当前在第一页，不需要红点提示，刷新订单即可
    }
    //加红点
    UITabBarItem *item=[self.mainTabBarController.tabBar.items objectAtIndex:XYTabBarItemTypeOrder];
    item.badgeCenterOffset = CGPointMake(-SCREEN_WIDTH/8+10, 10);
    [item showBadge];
}

- (void)showRedPointOnMap{

    if ((!self.mainTabBarController) || self.mainTabBarController.selectedIndex == XYTabBarItemTypeMap) {
        return;//当前在第二页，不需要提示
    }
    
    //加红点
    UITabBarItem *item=[self.mainTabBarController.tabBar.items objectAtIndex:XYTabBarItemTypeMap];
    item.badgeCenterOffset = CGPointMake(-SCREEN_WIDTH/8+10, 10);
    [item showBadge];
}

- (void)showRedPointOnNews{
   [self.adminViewController showRedSpotOnNews];
}

- (void)showRedPointOnAttendance{
    [self.adminViewController showRedSpotOnAttendance];
}

- (void)showRedPointOnParts{
    [self.personalCenterViewController showRedSpotOnParts];
}

//启动时展示公告页（与普通前后台弹出层级不同）
- (void)presentNewsListOnLaunch{
    XYNoticeListViewController* noticeListViewController = [[XYNoticeListViewController alloc]init];
    [self.adminNavigationController pushViewController:noticeListViewController animated:true];
}

//启动时展示配件（与普通前后台弹出层级不同）
- (void)presentPartsListOnLaunch{
    XYMyPartsViewController* noticeListViewController = [[XYMyPartsViewController alloc]init];
    [self.personalNavigationController pushViewController:noticeListViewController animated:true];
}

- (void)presentAttendanceOnLaunch{
    XYAttendenceViewController* noticeListViewController = [[XYAttendenceViewController alloc]init];
    [self.adminNavigationController pushViewController:noticeListViewController animated:true];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    CATransition *transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 1.0;
    //apply transition to tab bar controller's view
    [self.tabBarController.view.layer addAnimation:transition forKey:nil];
    
    if (viewController == self.adminNavigationController) {
        self.adminViewController.isFromTabSelection = true;
    }else if(viewController == self.mapNavigationController){
        UITabBarItem *item=[self.mainTabBarController.tabBar.items objectAtIndex:XYTabBarItemTypeMap];
        [item clearBadge];
        self.mapViewController.isFromTabSelection = true;
    }else if(viewController == self.orderNavigationController){
        UITabBarItem *item=[self.mainTabBarController.tabBar.items objectAtIndex:XYTabBarItemTypeOrder];
        [item clearBadge];
    }
    return true;
}

#pragma mark - style

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

#pragma mark - property

- (UITabBarController*)mainTabBarController{
    if (!_mainTabBarController) {
        _mainTabBarController = [[UITabBarController alloc] init];
        _mainTabBarController.delegate = self;
        _mainTabBarController.tabBar.tintColor = THEME_COLOR;
    }
    return _mainTabBarController;
}

- (void)updateTabBar{
    //如果是推广号 只显示个人中心
    if ([XYAPPSingleton sharedInstance].currentUser.is_promotion == XYUserTypePromoter) {
        [self.mainTabBarController setViewControllers:@[self.personalNavigationController]];
    }else{
        [self.mainTabBarController setViewControllers:@[self.adminNavigationController,self.orderNavigationController,self.mapNavigationController, self.personalNavigationController]];
    }
}

- (XYAdminMainViewController*)adminViewController{
    if (!_adminViewController) {
        _adminViewController = [[XYAdminMainViewController alloc]init];
        _adminViewController.title = @"首页";
        _adminViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_admin_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _adminViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_admin_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _adminViewController;
}

- (XYBaseNavigationController*)adminNavigationController{
    if (!_adminNavigationController) {
        _adminNavigationController = [[XYBaseNavigationController alloc] initWithRootViewController:self.adminViewController];
    }
    return _adminNavigationController;
}

- (XYOrderListViewController*)orderListViewController{
    if (!_orderListViewController) {
        _orderListViewController = [[XYOrderListViewController alloc]init];
        _orderListViewController.title = @"我的订单";
        _orderListViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_main_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _orderListViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_main_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _orderListViewController;
}

- (XYBaseNavigationController*)orderNavigationController{
    if (!_orderNavigationController) {
        _orderNavigationController = [[XYBaseNavigationController alloc] initWithRootViewController:self.orderListViewController];
    }
    return _orderNavigationController;
}

- (XYOrderListMapViewController*)mapViewController{
    if (!_mapViewController) {
        _mapViewController = [[XYOrderListMapViewController alloc]init];
        _mapViewController.title = @"订单地图";
        _mapViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_map_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _mapViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_map_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _mapViewController;
}

- (XYBaseNavigationController*)mapNavigationController{
    if (!_mapNavigationController) {
        _mapNavigationController = [[XYBaseNavigationController alloc] initWithRootViewController:self.mapViewController];
    }
    return _mapNavigationController;
}

- (XYPersonalCenterViewController*)personalCenterViewController{
    if (!_personalCenterViewController) {
        _personalCenterViewController = [[XYPersonalCenterViewController alloc]init];
        _personalCenterViewController.title = @"个人中心";
        _personalCenterViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"tab_user_select"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _personalCenterViewController.tabBarItem.image = [[UIImage imageNamed:@"tab_user_normal"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    return _personalCenterViewController;
}

- (XYBaseNavigationController*)personalNavigationController{
    if (!_personalNavigationController) {
        _personalNavigationController = [[XYBaseNavigationController alloc] initWithRootViewController:self.personalCenterViewController];
    }
    return _personalNavigationController;
}

- (XYLoginViewController*)loginViewController{
    if (!_loginViewController) {
        _loginViewController = [[XYLoginViewController alloc]init];
    }
    return _loginViewController;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
