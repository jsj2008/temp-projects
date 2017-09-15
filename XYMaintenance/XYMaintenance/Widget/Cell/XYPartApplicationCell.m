//
//  XYPartApplicationCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplicationCell.h"

@interface XYPartApplicationCell()
@property (weak, nonatomic) IBOutlet UILabel *partIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *mouldNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation XYPartApplicationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setRightUtilityButtons:[self rightButtons] WithButtonWidth:50.0f];
}

- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    NSDictionary *attrDict = @{
                               NSFontAttributeName : [UIFont systemFontOfSize:13],
                               NSForegroundColorAttributeName : XY_HEX(0xffffff)
                               };
    NSMutableAttributedString *editButton1Title = [[NSMutableAttributedString alloc] initWithString:@"编辑" attributes: attrDict];
    NSMutableAttributedString *delButtonTitle = [[NSMutableAttributedString alloc] initWithString:@"删除" attributes: attrDict];
    [rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0x009cff) attributedTitle:editButton1Title];
    [rightUtilityButtons sw_addUtilityButtonWithColor:XY_HEX(0xff4b4b) attributedTitle:delButtonTitle];
    
    return rightUtilityButtons;
}

-(void)setPartsSelection:(XYPartsSelectionDto *)partsSelection {
    _partsSelection = partsSelection;
    
    self.partIdLabel.text = _partsSelection.serial_number;
    self.mouldNameLabel.text = _partsSelection.mould_name;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", (long)_partsSelection.count];
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", _partsSelection.count*[_partsSelection.master_avg_price floatValue]];
    
}
@end
