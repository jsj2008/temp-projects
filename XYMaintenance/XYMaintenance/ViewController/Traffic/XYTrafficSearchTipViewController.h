//
//  XYTrafficSearchTipViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/9.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"


@protocol XYTrafficSearchTipDelegate <NSObject>

-(void)onLocationTipSelected:(NSString*)locName;

@end

@class AMapSearchAPI;

@interface XYTrafficSearchTipViewController : XYBaseViewController
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, weak) id<XYTrafficSearchTipDelegate> delegate;
@end
