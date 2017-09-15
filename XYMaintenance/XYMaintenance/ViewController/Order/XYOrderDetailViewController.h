//
//  XYOrderDetailViewController.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/21.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYOrderDetailDelegate <NSObject>
- (void)onOrderStatusChanged:(XYOrderBase*)order;
@end

@interface XYOrderDetailViewController : XYBaseViewController
@property(assign,nonatomic)id<XYOrderDetailDelegate>delegate;
- (id)initWithOrderId:(NSString *)orderId brand:(XYBrandType)type;
@end
