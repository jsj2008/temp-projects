//
//  XYSelectAreaViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/17.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYSelectAreaDelegate <NSObject>
-(void)onAreaSelected:(NSString*)areaId areaName:(NSString*)name;
@end

@interface XYSelectAreaViewController : XYBaseViewController
@property(assign,nonatomic) id<XYSelectAreaDelegate> delegate;
-(id)initWithCityId:(NSString*)cityId;
@end
