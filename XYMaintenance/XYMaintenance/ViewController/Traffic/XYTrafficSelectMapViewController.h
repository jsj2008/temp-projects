//
//  XYTrafficSelectMapViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYTrafficMapLocationDelegate <NSObject>

-(void)onTrafficLocationSelected:(NSString*)locString;//暂定

@end

@class AMapSearchAPI;

@interface XYTrafficSelectMapViewController : XYBaseViewController
@property (nonatomic, strong) AMapSearchAPI *search;
@property(assign,nonatomic)id<XYTrafficMapLocationDelegate> locDelegate;
@end
