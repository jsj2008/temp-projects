//
//  XYRankViewController.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYBaseViewController.h"


@protocol XYRankViewDelegate <NSObject>
//更新我的排名
- (void)onMyRankLoaded:(XYRankDto*)myRank;

@end

@interface XYRankViewController : XYBaseViewController

@property(assign,nonatomic) id<XYRankViewDelegate> delegate;

@end
