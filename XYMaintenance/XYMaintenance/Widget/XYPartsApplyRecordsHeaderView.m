//
//  XYPartsApplyRecordsHeaderView.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/17.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartsApplyRecordsHeaderView.h"

@interface XYPartsApplyRecordsHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLable;

@end

@implementation XYPartsApplyRecordsHeaderView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYPartsApplyRecordsHeaderView" owner:self options:nil] objectAtIndex:0];
    return self;
}

-(void)setPartApplyLogDto:(XYPartsApplyLogDto *)partApplyLogDto {
    _partApplyLogDto = partApplyLogDto;
    
    self.statusLabel.text = [NSString stringWithFormat:@"申请状态：%@", _partApplyLogDto.status_name];
    self.timeLabel.text = [NSString stringWithFormat:@"申请日期：%@", _partApplyLogDto.recordTimeStr];
    self.totalPriceLable.text = [NSString stringWithFormat:@"申请总额：¥%@", _partApplyLogDto.total_price];
}

@end
