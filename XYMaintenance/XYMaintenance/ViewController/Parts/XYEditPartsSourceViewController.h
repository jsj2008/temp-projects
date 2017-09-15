//
//  XYEditPartsSourceViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/19.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYEditPartsSourceDelegate <NSObject>

-(void)onPartsSourceEdited;

@end

@interface XYEditPartsSourceViewController : XYBaseViewController
@property(assign,nonatomic)id<XYEditPartsSourceDelegate> delegate;
@property(weak,nonatomic)XYOrderDetail* order;
@end
