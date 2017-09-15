//
//  XYPartsFlowCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/11/22.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPartsFlowCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYPartsFlowCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *remanentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;

@end

@implementation XYPartsFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.deviderHeight.constant = LINE_HEIGHT;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
    return @"XYPartsFlowCell";
}

+ (CGFloat)defaultHeight{
    return 137;
}

- (void)setData:(XYPartsLogDto*)data{
    
    if (!data) {
        return;
    }
    self.orderIdLabel.text = [NSString stringWithFormat:@"流水号：%@",data.id];
    self.timeLabel.text = [NSString stringWithFormat:@"时间：%@",data.created_at];
    self.nameLabel.text = [NSString stringWithFormat:@"名称：%@",data.part_name];
    self.directionLabel.text = [NSString stringWithFormat:@"走向：%@",data.meta];
    self.amountLabel.text = [NSString stringWithFormat:@"数量：%@",@(data.num)];
    self.remanentLabel.text = [NSString stringWithFormat:@"剩余：%@",@(data.storage_left_num)];
    
    self.typeLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"类型：%@",data.operate_name] lightRange:[NSString stringWithFormat:@"%@",data.operate_name] lightColor:[self getTypeColorByNum:data.num]];
}

- (UIColor*)getTypeColorByNum:(NSInteger)num{
    if (num >= 0) {
        return THEME_COLOR;
    }else{
        return REVERSE_COLOR;
    }
}

@end
