//
//  XYRouteHeaderView.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XYRouteHeaderViewDelegate <NSObject>

- (void)onReverseButtonClicked;

@end

@interface XYRouteHeaderView : UIView

@property(assign,nonatomic) id<XYRouteHeaderViewDelegate> delegate;

@property(strong,nonatomic) UILabel* startLocLabel;
@property(strong,nonatomic) UILabel* endLocLabel;

@property(assign,nonatomic) BOOL isReversed;

@end
