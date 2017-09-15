//
//  XYOrderListMapCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/30.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

@interface XYOrderListMapCell : UICollectionViewCell

@property (weak, nonatomic) UILabel* label;

+ (NSString*)defaultReuseId;
+ (CGFloat)getHeight;

- (void)setData:(XYOrderBase*)orderBase;

@end
