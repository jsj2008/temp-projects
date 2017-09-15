//
//  XYAdminMainViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYAdminMainViewController : XYBaseViewController
@property(assign,nonatomic)BOOL isFromTabSelection;//显示高度调整

//收到通知，弹出公告列表
- (void)showNewsList;
- (void)showRedSpotOnNews;
//考勤
- (void)goToAttendanceView;
- (void)showRedSpotOnAttendance;
@end
