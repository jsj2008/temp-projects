//
//  XYInputCustomDeviceViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/6/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYCustomDeviceDelegate <NSObject>
- (void)onCustomDeviceSaved:(NSString*)product brand:(NSString*)brand device:(NSString*)device price:(NSInteger)price;
@end


@interface XYInputCustomDeviceViewController : XYBaseViewController



@property(assign,nonatomic) id<XYCustomDeviceDelegate> delegate;

@property(strong,nonatomic) NSString* preProductName;
@property(strong,nonatomic) NSString* preBrandName;
@property(strong,nonatomic) NSString* preDeviceName;
@property(strong,nonatomic) NSString* preDevicePrice;

@end
