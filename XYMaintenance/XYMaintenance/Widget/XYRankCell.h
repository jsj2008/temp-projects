//
//  XYRankCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/2/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYRankDto.h"

@interface XYRankCell : UITableViewCell

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;
//订单排行
- (void)setRankData:(XYRankDto*)data;
//地推排行
- (void)setPromotionData:(XYPromotionRankDto*)data type:(XYRankingListType)type;

@end
