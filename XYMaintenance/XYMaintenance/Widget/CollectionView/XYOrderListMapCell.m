//
//  XYOrderListMapCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/30.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListMapCell.h"
#import "XYConfig.h"

static NSString *const XYOrderListMapCellIdentifier = @"XYOrderListMapCellIdentifier";

@interface XYOrderListMapCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceLabel;
@property (weak, nonatomic) IBOutlet UILabel *colorLabel;
@property (weak, nonatomic) IBOutlet UILabel *faultLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

@end


@implementation XYOrderListMapCell

- (void)awakeFromNib{
    self.backgroundColor = [UIColor whiteColor];
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
    
    self.nameLabel.text = XY_NOTNULL(data.uName, @"客户姓名");
    self.timeLabel.text = XY_NOTNULL(data.repairTimeString, @"预约时间");
    self.colorLabel.text = XY_NOTNULL(data.color,@"颜色");
    self.deviceLabel.text = XY_NOTNULL(data.MouldName, @"设备类型");
    self.faultLabel.text = XY_NOTNULL(data.FaultTypeDetail, @"故障类型");
    self.addrLabel.text = XY_NOTNULL(data.address, @"地址");

}




@end
