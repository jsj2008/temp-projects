//
//  XYCancelOrderViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/3/31.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"


@interface XYCancelOrderViewController : XYBaseViewController
@property(strong,nonatomic)NSString* orderId;
@property(assign,nonatomic)XYBrandType bid;
@end
