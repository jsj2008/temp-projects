//
//  XYRepairDetailViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/14.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"
#import "XYOrderDetailViewModel.h"

@interface XYRepairDetailViewController : XYBaseViewController

@property(strong,nonatomic)NSString* device;
@property(strong,nonatomic)NSString* plan;
@property(strong,nonatomic)NSString* parts;
@property(assign,nonatomic)CGFloat totalPrice;
@property(weak,nonatomic)XYOrderDetailViewModel* viewModel;

@end
