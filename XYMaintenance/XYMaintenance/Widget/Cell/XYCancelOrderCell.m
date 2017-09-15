//
//  XYCancelOrderCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/4/6.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYCancelOrderCell.h"
#import "XYConfig.h"

@interface XYCancelOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipIcon;


@end

@implementation XYCancelOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statusLabel.textColor = THEME_COLOR;
    self.vipIcon.layer.borderWidth = LINE_HEIGHT;
    self.vipIcon.layer.borderColor = XY_HEX(0x1787ff).CGColor;
    self.vipIcon.layer.cornerRadius = 4.0f *LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYCancelOrderCell";
}

+ (CGFloat)getHeight{
    return 68;
}

- (void)setData:(XYCancelOrderDto*)data type:(BOOL)isPending{
    
    if (!data) {
        return;
    }
    
    self.vipIcon.hidden = !data.isVip;
    self.nameLabel.text = XY_NOTNULL(data.user_name, @"客户姓名");
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单:%@",(data.bid == XYBrandTypeMeizu)?data.order_num:data.order_id];
    self.statusLabel.text = isPending?@"待审核":@"审核通过";
    self.faultLabel.text = XY_NOTNULL(data.fault, @"故障");
    self.deviceLabel.text = XY_NOTNULL(data.mould, @"机型");
}

@end
