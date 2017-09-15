//
//  XYRouteDetailViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/4.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>

typedef NS_ENUM(NSInteger, XYBMKRouteSearchType)
{
    XYBMKRouteLineTypeBus = 0,
    XYBMKRouteLineTypeDriving = 1,
    XYBMKRouteLineTypeWalking = 2,
};

@interface XYRouteDetailViewController : XYBaseViewController

-(id)initWithRouteLine:(BMKRouteLine*)plan type:(XYBMKRouteSearchType)type;

-(void)setRouteLine:(BMKRouteLine*)plan type:(XYBMKRouteSearchType)type;

@end
