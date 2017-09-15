//
//  XYAlertTool.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+Blocks.h"

typedef void (^XYAlertToolBlock)();

@interface XYAlertTool : NSObject

+(void)showAllowNotifcationAlert;
+(void)showPhoneAlert:(NSString*)phone onView:(UIViewController*)viewController;
+ (void)callPhone:(NSString*)phone onView:(UIViewController *)viewController;
+(void)showUpdateAlert:(NSString*)message appId:(NSString*)url onView:(UIViewController*)viewController;

+(void)showConfirmCancelAlert:(NSString*)title message:(NSString*)msg onView:(UIViewController*)viewController action:(XYAlertToolBlock)onConfirmed cancel:(XYAlertToolBlock)onCancelled;
@end
