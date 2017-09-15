//
//  XYApplyRecordCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/10.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYApplyRecordCell.h"

@interface XYApplyRecordCell()
@property (weak, nonatomic) IBOutlet UILabel *partNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *mouldLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

@implementation XYApplyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString*)defaultReuseId{
    return @"XYApplyRecordCell";
}


-(void)setPartApplyLogDetailDto:(XYPartsApplyLogDetailDto *)partApplyLogDetailDto {
    _partApplyLogDetailDto = partApplyLogDetailDto;
    self.partNameLabel.text =  XY_NOTNULL(_partApplyLogDetailDto.part_name, @"配件名称");
    self.countLabel.text = XY_NOTNULL(_partApplyLogDetailDto.part_num, @"配件数量");
    self.mouldLabel.text = XY_NOTNULL(_partApplyLogDetailDto.mould_name, @"机型名称");
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", _partApplyLogDetailDto.total_price];
}

@end
