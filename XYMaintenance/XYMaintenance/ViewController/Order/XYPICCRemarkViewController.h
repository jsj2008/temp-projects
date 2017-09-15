//
//  XYPICCRemarkViewController.h
//  XYMaintenance
//
//  Created by Kingnet on 16/9/26.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"

@protocol XYPICCRemarkDelegate <NSObject>

- (void)onRemarkSaved:(NSString*)selection remark:(NSString*)remark joint:(NSString*)jointString;

@end

@interface XYPICCRemarkViewController : XYBaseViewController

@property (assign,nonatomic) id<XYPICCRemarkDelegate> delegate;
@property (assign,nonatomic) BOOL editable;
@property (strong, nonatomic) NSString* remark;//格式@“%@-%@” xx购买 备注详情

@end
