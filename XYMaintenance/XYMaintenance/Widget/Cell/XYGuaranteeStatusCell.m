//
//  XYGuaranteeStatusCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/9/28.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYGuaranteeStatusCell.h"

@implementation XYGuaranteeStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)guaranteedClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(willChangeGuaranteeStatusInto:)]) {
       [self.delegate willChangeGuaranteeStatusInto:XYGuarrantyStatusInGuarranty];
    }
}
- (IBAction)unGuaranteedClicked:(id)sender {
    if ([self.delegate respondsToSelector:@selector(willChangeGuaranteeStatusInto:)]) {
       [self.delegate willChangeGuaranteeStatusInto:XYGuarrantyStatusNoGuarranty];
    }
}

+ (NSString*)defaultReuseId{
    return @"XYGuaranteeStatusCell";
}

- (void)setGuaranteeStatus:(XYGuarrantyStatus)status{
    switch (status) {
        case XYGuarrantyStatusInGuarranty:
        {
            [self.guaranteeButton setImage:[UIImage imageNamed:@"btn_ok"] forState:UIControlStateNormal];
            [self.unGuaranteeButton setImage:[UIImage imageNamed:@"btn_ok_bg"] forState:UIControlStateNormal];
        }
            break;
        case XYGuarrantyStatusNoGuarranty:
        {
            [self.guaranteeButton setImage:[UIImage imageNamed:@"btn_ok_bg"] forState:UIControlStateNormal];
            [self.unGuaranteeButton setImage:[UIImage imageNamed:@"btn_ok"] forState:UIControlStateNormal];
        }
            break;
        default:
        {
            [self.guaranteeButton setImage:[UIImage imageNamed:@"btn_ok_bg"] forState:UIControlStateNormal];
            [self.unGuaranteeButton setImage:[UIImage imageNamed:@"btn_ok_bg"] forState:UIControlStateNormal];
        }
            break;
    }
}

@end
