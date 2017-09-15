//
//  XYTrafficAddFeeViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/24.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYTrafficAddFeeDelegate <NSObject>

-(void)onXYTrafficEditFeesSuccess;

@end

@interface XYTrafficAddFeeViewController : XYBaseViewController

@property(assign,nonatomic)id<XYTrafficAddFeeDelegate> delegate;
-(id)initWithEditable:(BOOL)canEdit date:(NSString*)date;
@end
