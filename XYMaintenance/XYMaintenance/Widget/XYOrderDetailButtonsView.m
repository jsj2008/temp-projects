//
//  XYOrderDetailButtonsView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/11/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYOrderDetailButtonsView.h"
#import "XYConfig.h"
#import "XYWidgetUtil.h"

@implementation XYOrderDetailButtonsView

+ (XYOrderDetailButtonsView*)buttonsViewWithFrame:(CGRect)frame{
    XYOrderDetailButtonsView* buttonsView = [[XYOrderDetailButtonsView alloc]initWithFrame:frame];
    buttonsView.backgroundColor = [UIColor whiteColor];
    [buttonsView addSubview:[XYWidgetUtil getSingleLineWithColor:XY_COLOR(207,214,224)]];
    return buttonsView;
}

- (void)resetWithButtons:(NSArray*)buttons{
    for (id subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    NSInteger buttonsCount = [buttons count];
    if (buttonsCount > 0) {
        self.hidden = false;
        for (NSInteger i = 0 ; i < buttonsCount; i ++ ){
            UIButton* utilityBtn = [buttons objectAtIndex:i];
            CGFloat btnWidth = (SCREEN_WIDTH - 30 - (buttonsCount-1)*10)/buttonsCount;
            UIButton* detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            detailBtn.frame = CGRectMake(15 + (btnWidth+10) * i, 10, btnWidth, 40);
            [detailBtn setTitle:utilityBtn.titleLabel.text forState:UIControlStateNormal];
            detailBtn.titleLabel.font = [UIFont systemFontOfSize: 16 - buttonsCount];
            [detailBtn setBackgroundColor:utilityBtn.backgroundColor];
            detailBtn.userInteractionEnabled = utilityBtn.userInteractionEnabled;
            detailBtn.layer.cornerRadius = 20.0f;
            detailBtn.layer.masksToBounds = true;
            detailBtn.tag = i;
            [detailBtn addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:detailBtn];
        }
    }else{
        self.hidden = true;
    }
}

- (void)buttonClicked:(UIButton*)sender{
    self.tapBlock(sender.tag);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
