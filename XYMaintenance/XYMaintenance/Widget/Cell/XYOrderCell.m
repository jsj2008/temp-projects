//
//  XYOrderCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/30.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderCell.h"


@interface XYOrderCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *unpaidNoteLabel;
@end

@implementation XYOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(CGFloat)defaultHeight
{
    return 90;
}

+(NSString*)defaultReuseId
{
    return @"XYOrderCell";
}

-(void)setData:(XYOrderBase*)data;
{
    NSLog(@"data = %@",data);
    if (data == nil)
    {
        return;
    }
    
    self.orderIdLabel.text = [NSString stringWithFormat:@"订单号:%@",data.orderNumber];
    self.statusLabel.text = [self getTextOfOrderStatus:data.status hasPaid:data.hasPaid]; //TBD
    self.deviceTypeLabel.text = [NSString stringWithFormat:@"故障机型:%@",data.deviceType];
    self.endingTimeLabel.text = data.time; //TBD 要根据status来搞
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2ld",(long)data.price];
    self.unpaidNoteLabel.hidden = data.hasPaid;
    [self.statusButton setTitle:[self getTextOfOrderStatus:[self getNextStatus:data.status] hasPaid:data.hasPaid] forState:UIControlStateNormal];
   
    if (data.status == XYOrderStatusDone && data.hasPaid)
    {
        self.statusButton.hidden = true;
    }
    else
    {
        self.statusButton.hidden = false;
    }
}

-(XYOrderStatus)getNextStatus:(XYOrderStatus)status;
{
    switch (status)
    {
        case XYOrderStatusSubmitted:
            return XYOrderStatusRepairing;
        case XYOrderStatusRepairing:
            return XYOrderStatusDone;
        case XYOrderStatusDone:
            return XYOrderStatusNothing;
        default:
            return XYOrderStatusSubmitted;
            break;
    }
}

- (NSString*)getTextOfOrderStatus:(XYOrderStatus)status hasPaid:(BOOL)hasPaid
{
    switch (status)
    {
        case XYOrderStatusSubmitted:
            return @"已预约";
        case XYOrderStatusRepairing:
            return @"维修中";
        case XYOrderStatusDone:
            return @"维修完成";
        case XYOrderStatusCancelled:
            return @"已取消";

        default:
            if (hasPaid)
            {
                return @"";
            }
            else
            {
                return @"现金支付";
            }
            
            break;
    }
}

@end
