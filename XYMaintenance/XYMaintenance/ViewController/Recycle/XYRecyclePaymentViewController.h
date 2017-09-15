//
//  XYRecyclePaymentViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/7/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYRecycleUserInfoViewModel.h"

@interface XYRecyclePaymentViewController : XYBaseViewController<XYRecycleUserInfoCallBackDelegate>

@property(assign,nonatomic)XYRecycleUserInfoViewModel* viewModel;


@end
