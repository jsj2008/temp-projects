//
//  XYAlertTool.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAlertTool.h"
#import "XYConfig.h"
#import "UIView+Toast.h"

@implementation XYAlertTool

+ (void)showAllowNotifcationAlert{
    [UIAlertView showWithTitle:@"您尚未开启推送通知" message:@"请开启推送通知，以保证您实时接收订单与公告信息" cancelButtonTitle:nil otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
        [[UIApplication sharedApplication] openURL:url];
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:false];
    }];
}

+ (void)showPhoneAlert:(NSString *)phone onView:(UIViewController *)viewController{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打电话" message:phone preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[alertController dismissViewControllerAnimated:true completion:^{
        TTDEBUGLOG(@"???");
    }];}]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[XYAlertTool callPhone:phone onView:viewController];}]];
    [viewController presentViewController:alertController animated:YES completion:^{}];
}

+ (void)callPhone:(NSString*)phone onView:(UIViewController *)viewController{
    #warning XYAlertTool
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *phoneUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phone]];
    
    if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
        [application openURL:phoneUrl options:@{}
           completionHandler:^(BOOL success) {
               if (!success) {
                   [viewController.view makeToast:@"设备无法拨打该电话" duration:1.0 position:CSToastPositionCenter];
               }
           }];
    } else {
        BOOL success = [application openURL:phoneUrl];
        if (!success) {
            [viewController.view makeToast:@"设备无法拨打该电话" duration:1.0 position:CSToastPositionCenter];
        }
    }
}

+ (void)showUpdateAlert:(NSString*)message appId:(NSString*)url onView:(UIViewController*)viewController{
    if (IS_IOS_8_LATER) {//ios8新alert控件 防止键盘闪烁
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"版本更新" message:message preferredStyle:UIAlertControllerStyleAlert];
//        [alertController addAction:[UIAlertAction actionWithTitle:@"稍后" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[alertController dismissViewControllerAnimated:true completion:nil];}]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"立即更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {[XYAlertTool goToAppStore:url];}]];
        [viewController presentViewController:alertController animated:YES completion:^{}];
        return;
    }else{//ios7老控件
        [UIAlertView showWithTitle:@"版本更新" message:message cancelButtonTitle:nil otherButtonTitles:@[@"立即更新"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [XYAlertTool goToAppStore:url];
        }];
        return;
    }
}

+ (void)goToAppStore:(NSString*)appId{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appId]];
}

+(void)showConfirmCancelAlert:(NSString*)title message:(NSString*)msg onView:(UIViewController*)viewController action:(XYAlertToolBlock)onConfirmed cancel:(XYAlertToolBlock)onCancelled{
    if (IS_IOS_8_LATER) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            onCancelled?onCancelled():nil;
            [alertController dismissViewControllerAnimated:true completion:^{}];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {onConfirmed();}]];
        [viewController presentViewController:alertController animated:YES completion:^{}];
    }else{
        [UIAlertView showWithTitle:title message:msg cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if(buttonIndex==1){
                onConfirmed();
            }else{
                onCancelled?onCancelled():nil;
            }
        }];
    }
}

@end
