//
//  XYLeaveListCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/7/12.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYLeaveListCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYLeaveListCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;
@property (weak, nonatomic) IBOutlet UIView *deviderLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@end


@implementation XYLeaveListCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.deviderHeight.constant = LINE_HEIGHT;
    [self.actionButton setTitleColor:THEME_COLOR forState:UIControlStateNormal];;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReuseId{
   return @"XYLeaveListCell";
}

+ (CGFloat)defaultHeight{
    return 200;
}

+ (CGFloat)foldedHeight{
    return 45;
}

- (void)setLeaveData:(XYLeaveDto*)data{

    if (!data) {
        return;
    }
    
    self.dateLabel.text = XY_NOTNULL([data.leave_at substringWithRange:NSMakeRange(0, 10)], @"0000-00-00");
    self.leftDetailLabel.text = [NSString stringWithFormat:@"请假原因：%@",data.leaveTypeStr];
    self.detailLabel.text = [NSString stringWithFormat:@"审批人：%@\n\n审批结果：%@\n\n审批时间：%@\n\n审批备注：%@",XY_NOTNULL(data.checked_by,@"无"),data.statusStr,data.updatedStr,XY_NOTNULL(data.checked_remark,@"无")];
    [self.detailLabel sizeToFit];
    [self setFolded:!data.isExpanded];
    
    if (data.status == XYLeaveReviewTypeRejected) {
        self.rightDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"%@",data.statusStr] lightRange:data.statusStr lightColor:THEME_COLOR];
    }else{
       self.rightDetailLabel.text = [NSString stringWithFormat:@"%@",data.statusStr];
    }
}

- (void)setFolded:(BOOL)folded{
    self.deviderLine.hidden = folded;
    self.detailLabel.hidden = folded;
}
@end
