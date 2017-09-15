//
//  AppDelegate.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/13.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XYRootViewController;
@class XYUserDto;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (retain, nonatomic, readonly) XYRootViewController* rootViewController;
@property (strong, nonatomic) UIWindow *window;

- (void)showLoginView;

@end

