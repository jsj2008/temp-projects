//
//  XYOrderDetailButtonsView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/11/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^XYOrderDetailButtonsViewBlock) (NSInteger buttonIndex);

@interface XYOrderDetailButtonsView : UIView

@property (strong,nonatomic)XYOrderDetailButtonsViewBlock tapBlock;

+ (XYOrderDetailButtonsView*)buttonsViewWithFrame:(CGRect)frame;

- (void)resetWithButtons:(NSArray*)buttons;

@end
