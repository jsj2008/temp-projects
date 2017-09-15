//
//  XYEvaluationReturnVisitCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYEvaluationReturnVisitCell.h"

@interface XYEvaluationReturnVisitCell()
@property (weak, nonatomic) IBOutlet UILabel *favorableRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *acceptOrderCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterSaleOrderCountLabel;

@end

@implementation XYEvaluationReturnVisitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setEvaluationDto:(XYEvaluationDto *)evaluationDto {
    _evaluationDto = evaluationDto;
    self.favorableRateLabel.text = XY_NOTNULL(_evaluationDto.favorable_rate, @"--");
    self.afterSaleOrderCountLabel.text = _evaluationDto.afterSale_order_count;
    self.acceptOrderCountLabel.text = _evaluationDto.accept_order_count;

}
@end
