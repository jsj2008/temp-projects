//
//  XYGuaranteeStatusCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/9/28.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYOrderDto.h"

@protocol XYGuaranteeStatusDelegate <NSObject>
- (void)willChangeGuaranteeStatusInto:(XYGuarrantyStatus)status;
@end

@interface XYGuaranteeStatusCell : UITableViewCell
@property (assign,nonatomic) id<XYGuaranteeStatusDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *guaranteeButton;
@property (weak, nonatomic) IBOutlet UIButton *unGuaranteeButton;
+ (NSString*)defaultReuseId;
- (void)setGuaranteeStatus:(XYGuarrantyStatus)status;//XYGuarrantyStatus
@end
