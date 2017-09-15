//
//  XYEditProfileViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/29.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"



@interface XYEditProfileViewModel : XYBaseViewModel

/**
 *  修改头像
 */
- (void)editAvatar:(UIImage*)img;

/**
 *  修改手机号
 */
- (void)editPhone:(NSString*)phone;

@end
