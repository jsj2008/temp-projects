//
//  XYSelectPICCPlanViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYSelectPICCPlanDelegate <NSObject>
-(void)onPlanSelected:(NSString*)planId planName:(NSString*)name;
@end

@interface XYSelectPICCPlanViewController : XYBaseViewController
@property(assign,nonatomic) id<XYSelectPICCPlanDelegate> delegate;
-(id)initWithCompanyId:(NSString*)companyId;
@end

