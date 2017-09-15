//
//  XYNoticeDetailViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYNoticeDetailViewController : XYBaseViewController
@property (copy,nonatomic) NSString* noticeId;
@property (copy,nonatomic) NSString* linkUrl;
@property (assign,nonatomic) NSInteger view_count;
@end
