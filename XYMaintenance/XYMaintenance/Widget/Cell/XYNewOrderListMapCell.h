//
//  XYNewOrderListMapCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/3.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

@protocol XYNewOrderListMapCellDelegate <NSObject>
- (void)startNavigationToOrder:(NSString*)orderId;
@end

@interface XYNewOrderListMapCell : UITableViewCell

@property (assign,nonatomic) id<XYNewOrderListMapCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *bidLabel;


+ (NSString*)defaultReuseId;
+ (CGFloat)getHeight;

- (void)setData:(XYOrderBase*)orderBase;

@end
