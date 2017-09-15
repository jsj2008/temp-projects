//
//  XYPartApplicationSubmitView.h
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYPartApplyViewControllerDelegate <NSObject>
- (void)onSubmitButtonClicked;
@end

@interface XYPartApplicationSubmitView : UIView
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property(assign,nonatomic) id<XYPartApplyViewControllerDelegate> delegate;
@end
