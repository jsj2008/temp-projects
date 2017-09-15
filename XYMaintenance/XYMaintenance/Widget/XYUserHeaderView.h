//
//  XYUserHeaderView.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTO.h"

@interface XYUserHeaderView : UIView

@property(strong,nonatomic)UIButton* infoButton;

- (void)setUserInfo:(XYUserDto*)user;

@end
