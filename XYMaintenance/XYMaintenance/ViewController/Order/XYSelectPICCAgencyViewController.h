//
//  XYSelectPICCAgencyViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/5.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYSelectPICCAgencyDelegate <NSObject>
-(void)onAgencySelected:(NSString*)insurerId agency:(NSString*)insurerName plan:(NSString*)planId plan:(NSString*)areaName;
@end

@interface XYSelectPICCAgencyViewController : XYBaseViewController
@property(assign,nonatomic) id<XYSelectPICCAgencyDelegate> delegate;
@end
