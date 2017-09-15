//
//  XYNewOrderListMapCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/3.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYNewOrderListMapCell.h"
#import "XYConfig.h"

static NSString *const XYOrderListMapCellIdentifier = @"XYOrderListMapCellIdentifier";


@interface XYNewOrderListMapCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;
@property (weak, nonatomic) IBOutlet UIButton *naviButton;

@end

@implementation XYNewOrderListMapCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.naviButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return XYOrderListMapCellIdentifier;
}

+ (CGFloat)getHeight{
    return 135;
}

- (void)setData:(XYOrderBase*)data{
    
    if (!data) {
        return;
    }
    
    self.orderIdLabel.text = XY_NOTNULL(data.id, @"");
    self.bidLabel.text = [NSString stringWithFormat:@"%@",@(data.bid)];
    self.nameLabel.text = XY_NOTNULL(data.uName, @"客户姓名");
    self.timeLabel.text = XY_NOTNULL(data.repairTimeString, @"预约时间");
    self.colorLabel.text = XY_NOTNULL(data.color,@"颜色");
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.faultLabel.text = XY_NOTNULL(data.FaultTypeDetail, @"故障类型");
    self.addrLabel.text = XY_NOTNULL(data.address, @"地址");
}


- (IBAction)naviButtonClicked:(id)sender {
    if (self.delegate) {
        [self.delegate startNavigationToOrder:self.orderIdLabel.text];
    }
}
@end
