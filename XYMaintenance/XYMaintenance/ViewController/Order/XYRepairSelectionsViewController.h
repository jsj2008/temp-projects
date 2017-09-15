//
//  XYRepairSelectionsViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYRepairSelectionsViewController : XYBaseViewController

- (instancetype)initWithOrderId:(NSString*)orderId
                       orderNum:(NSString*)orderNumber
                            bid:(XYBrandType)bid
                    isAfterSale:(BOOL)afterSale;

@end
