//
//  XYPartApplyLogCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/22.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplyLogCell.h"

@interface XYPartApplyLogCell()
@property (weak, nonatomic) IBOutlet UILabel *oddNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end

@implementation XYPartApplyLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString*)defaultReuseId{
    return @"XYPartApplyLogCell";
}

+ (CGFloat)defaultHeight{
    return 60;
}

- (void)setData:(XYPartsApplyLogDto*)data{
    if (!data) {
        return;
    }
    self.oddNumberLabel.text = XY_NOTNULL(data.odd_number, @"批次号暂无");
    self.countLabel.text = XY_NOTNULL(data.total_num, @"数量暂无");
    self.totalPriceLabel.text = [NSString stringWithFormat:@"¥%@", data.total_price];
    self.statusLabel.text = data.status_name;
    switch (data.status) {
        case XYPartApplyLogStatusWait:
            self.statusLabel.textColor = XY_HEX(0xFF4B4B);
            break;
        case XYPartApplyLogStatusPass:
            self.statusLabel.textColor = XY_HEX(0x009cff);
            break;
        case XYPartApplyLogStatusReject:
            self.statusLabel.textColor = XY_HEX(0xff5000);
            break;
        case XYPartApplyLogStatusReceived:
            self.statusLabel.textColor = XY_HEX(0x666666);
            break;
            
        default:
            break;
    }
}

@end
