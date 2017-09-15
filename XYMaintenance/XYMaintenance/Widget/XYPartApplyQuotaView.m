//
//  XYPartApplyQuotaView.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplyQuotaView.h"

@interface XYPartApplyQuotaView()
@property (weak, nonatomic) IBOutlet UILabel *totalAmountLabel;
@property (weak, nonatomic) IBOutlet UILabel *availableAmountLabel;

@end

@implementation XYPartApplyQuotaView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYPartApplyQuotaView" owner:self options:nil] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 85);
    return self;
}

-(void)setPartAmount:(XYPartsAmountDto *)partAmount {
    _partAmount = partAmount;
    
    self.totalAmountLabel.text = [NSString stringWithFormat:@"%.2f", _partAmount.use_limit];
    self.availableAmountLabel.text = [NSString stringWithFormat:@"%.2f", _partAmount.use_limit_remain];
}

@end
