//
//  XYSelectCityViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYAddOrderViewModel.h"

@protocol XYSelectCityDelegate <NSObject>
-(void)onCitySelected:(NSString*)cityId city:(NSString*)cityName area:(NSString*)areaId area:(NSString*)areaName;
@end

@interface XYSelectCityViewController : XYBaseViewController
@property(assign,nonatomic) id<XYSelectCityDelegate> delegate;
@end
