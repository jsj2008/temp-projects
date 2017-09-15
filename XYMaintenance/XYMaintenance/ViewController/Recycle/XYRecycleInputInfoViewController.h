//
//  XYRecycleInputInfoViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@interface XYRecycleInputInfoViewController : XYBaseViewController

@property(strong,nonatomic)XYRecycleOrderDetail* preOrderDetail;//从前页传来
@property (assign,nonatomic)NSInteger estimatePrice;//回收估价

@end
