//
//  XYOrderListCell.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/12.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYOrderListCell.h"
#import "XYStringUtil.h"
#import "XYConfig.h"

@interface XYOrderListCell (){
    NSArray* _rightButtonsArray;
}
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endingTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIView *deviderLine;
@end

@implementation XYOrderListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.statusLabel.textColor = THEME_COLOR;
}/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(CGFloat)defaultHeight{
    return 109;
}

+(CGFloat)foldedHeight{
    return 40;
}

+ (NSString*)defaultReuseId{
    return @"XYOrderListCell";
}

- (void)setData:(XYOrderBase*)data{
    
    if (!data) {
        return;
    }
    
    self.orderIdLabel.text = XY_NOTNULL(data.uName, @"客户姓名");
    self.statusLabel.text = data.statusString;
    self.deviderLine.hidden = false;
    self.deviceTypeLabel.text = data.MouldName;
    
        switch (data.status){
            case XYOrderStatusSubmitted:
                self.endingTimeLabel.text = [NSString stringWithFormat:@"预约上门 %@",data.repairTimeString];
                break;
            case XYOrderStatusOnTheWay:
            case XYOrderStatusRepairing:
                self.endingTimeLabel.text = [NSString stringWithFormat:@"预计完成 %@",data.repairTimeString];
                break;
            case XYOrderStatusRepaired:
            case XYOrderStatusDone:
                self.endingTimeLabel.text = [NSString stringWithFormat:@"维修时间 %@",data.finishTimeString];
                break;
            default:
                self.endingTimeLabel.text = @"未知";
                break;
        }
    
    self.priceLabel.attributedText = data.priceAndPay;

}




@end
