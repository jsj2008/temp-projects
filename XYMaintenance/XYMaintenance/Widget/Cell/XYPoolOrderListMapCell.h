//
//  XYPoolOrderListMapCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCustomButton.h"
#import "XYOrderDto.h"

typedef NS_ENUM(NSInteger, XYPoolOrderListMapCellType) {
    XYPoolOrderListMapCellTypeUnknown = 0,
    XYPoolOrderListMapCellTypePool = 1,
    XYPoolOrderListMapCellTypeOvertime = 2,
};

@protocol XYPoolOrderListMapCellDelegate <NSObject>
- (void)acceptOrder:(NSString*)orderId bid:(XYBrandType)bid;
- (void)callEngineer:(NSString*)phone;
@end

@interface XYPoolOrderListMapCell : UITableViewCell
@property (assign,nonatomic) id<XYPoolOrderListMapCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;


+ (NSString*)defaultReuseId;
+ (CGFloat)getHeight;

- (void)setPoolOrderData:(XYOrderBase*)order;//可接订单
- (void)setOverTimeOrderData:(XYOrderBase*)order;//超时订单
@end
