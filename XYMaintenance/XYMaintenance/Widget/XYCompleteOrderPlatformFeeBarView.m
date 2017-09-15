//
//  XYCompleteOrderPlatformFeeBarView.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/12.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYCompleteOrderPlatformFeeBarView.h"
#import "XYAllTypeOrderDto.h"
@interface XYCompleteOrderPlatformFeeBarView()
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UILabel *feeCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@end

@implementation XYCompleteOrderPlatformFeeBarView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYCompleteOrderPlatformFeeBarView" owner:self options:nil] objectAtIndex:0];
    return self;
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 18;
}

-(void)setDataArr:(NSArray *)dataArr {
    NSMutableArray *selecedFees = [[NSMutableArray alloc] init];
    for (XYAllTypeOrderDto *feeDto in dataArr) {
        if (feeDto.platform_fee_selected) {
            [selecedFees addObject:feeDto];
        }
    }
    self.feeCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)selecedFees.count];
    CGFloat totalFees = 0.0;
    for (XYAllTypeOrderDto *feeDto in selecedFees) {
        totalFees += [feeDto.platform_fee floatValue];
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", totalFees];
}

- (IBAction)submit:(id)sender {
    !_submitFeeBlock ?: _submitFeeBlock();
}

@end
