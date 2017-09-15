//
//  XYRefreshLegendHeader.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/11.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRefreshLegendHeader.h"
#import "MJRefreshConst.h"
#import "UIView+MJExtension.h"
#import "HYCircleLoadingView.h"

@interface XYRefreshLegendHeader()
@property (nonatomic, weak) UIImageView *arrowImage;
@property (nonatomic, weak) HYCircleLoadingView *activityView;
@end

@implementation XYRefreshLegendHeader
#pragma mark - 懒加载
- (UIImageView *)arrowImage
{
    if (!_arrowImage) {
        UIImageView *arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
        [self addSubview:_arrowImage = arrowImage];
    }
    return _arrowImage;
}

- (HYCircleLoadingView *)activityView
{
    if (!_activityView) {
        HYCircleLoadingView *activityView = [[HYCircleLoadingView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        activityView.bounds = self.arrowImage.bounds;
        [self addSubview:_activityView = activityView];
    }
    return _activityView;
}

#pragma mark - 初始化
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.font = [UIFont systemFontOfSize:13.0f];
    
    // 箭头
    CGFloat arrowX = (self.stateHidden && self.updatedTimeHidden) ? self.mj_w * 0.5 : (self.mj_w * 0.5 - 60);
    self.arrowImage.center = CGPointMake(arrowX, self.mj_h * 0.5);
    
    // 指示器
    self.activityView.center = self.arrowImage.center;
}

#pragma mark - 公共方法
#pragma mark 设置状态
- (void)setState:(MJRefreshHeaderState)state
{
    if (self.state == state) return;
    
    // 旧状态
    MJRefreshHeaderState oldState = self.state;
    
    switch (state) {
        case MJRefreshHeaderStateIdle: {
            if (oldState == MJRefreshHeaderStateRefreshing) {
                self.arrowImage.transform = CGAffineTransformIdentity;
                [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                    self.activityView.alpha = 0.0;
                } completion:^(BOOL finished) {
                    self.arrowImage.alpha = 1.0;
                    self.activityView.alpha = 1.0;
                    [self.activityView stopAnimation];
                }];
            } else {
                [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                    self.arrowImage.transform = CGAffineTransformIdentity;
                }];
            }
            break;
        }
            
        case MJRefreshHeaderStatePulling: {
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowImage.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
            }];
            break;
        }
            
        case MJRefreshHeaderStateRefreshing: {
            [self.activityView startAnimation];
            self.arrowImage.alpha = 0.0;
            break;
        }
            
        default:
            break;
    }
    
    // super里面有回调，应该在最后面调用
    [super setState:state];
}


@end

