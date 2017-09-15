//
//  UIControl+XYButtonClickDelayer.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/23.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (XYButtonClickDelayer)
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;
@property (nonatomic, assign) BOOL uxy_ignoreEvent;
@end
