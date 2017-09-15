//
//  PlanCell.m
//  XYHiRepairs
//
//  Created by zhoujl on 15/11/4.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "PlanCell.h"

@interface PlanCell ()

@property (weak, nonatomic) IBOutlet UILabel *PriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *RepairTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *RepairTimeLabel;

@end

@implementation PlanCell

- (void)setPlan:(PlanResult *)plan
{
    _plan = plan;
    self.PriceLabel.text = [NSString stringWithFormat:@"¥ %@",plan.Price];
    self.RepairTypeLabel.text = [NSString stringWithFormat:@"维修方案: %@",plan.RepairType];
    self.faultTypeLabel.text = plan.faultType;
    self.RepairTimeLabel.text = [NSString stringWithFormat:@"维修时长: %@分",plan.RepairTime];
}

@end
