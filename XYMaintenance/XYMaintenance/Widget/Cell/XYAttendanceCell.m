//
//  XYAttendanceCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/4.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAttendanceCell.h"
#import "XYConfig.h"
#import "XYStringUtil.h"

@interface XYAttendanceCell ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;
@end

@implementation XYAttendanceCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAttendanceData:(XYAttendanceDto*)data{
    
    if (!data) {
        return;
    }
    
    self.dateLabel.text = XY_NOTNULL(data.create_at, @"0000-00-00");
    
    if (data.online_at > 0.5) {
        //有上班时间的 一律显示为上班
        //_sb_api_design
        self.leftDetailLabel.text = [NSString stringWithFormat:@"上班：%@",data.onlineStr];
        if (data.offline_at < 0.5) {
            self.rightDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"下班：%@",data.offlineStr] lightRange:data.offlineStr lightColor:THEME_COLOR];
        }else{
            self.rightDetailLabel.text = [NSString stringWithFormat:@"下班：%@",data.offlineStr];
        }
    }else{
        switch (data.status) {
            case XYAttendenceTypeWorking:{
                if (data.online_at < 0.5) {
                    self.leftDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString: [NSString stringWithFormat:@"上班：%@",data.onlineStr] lightRange:data.onlineStr lightColor:THEME_COLOR];
                }else{
                    self.leftDetailLabel.text = [NSString stringWithFormat:@"上班：%@",data.onlineStr];
                }
                if (data.offline_at < 0.5) {
                    self.rightDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"下班：%@",data.offlineStr] lightRange:data.offlineStr lightColor:THEME_COLOR];
                }else{
                    self.rightDetailLabel.text = [NSString stringWithFormat:@"下班：%@",data.offlineStr];
                }
            }
                break;
            case XYAttendenceTypeAbsence:
            case XYAttendenceTypeHoliday:{
                if(data.leave_status == XYLeaveReviewTypeApproved){//请假审核通过
                    //用请假状态判断请没过请假。。。猜的
                    self.leftDetailLabel.text = [NSString stringWithFormat:@"类型：%@",data.leaveTypeStr];
                    self.rightDetailLabel.text = [NSString stringWithFormat:@"时间：%@",data.create_at];
                }else{
                    self.leftDetailLabel.text = @"缺席";
                    self.rightDetailLabel.text = @"";
                }
            }
                break;
            default:
                break;
        }
    }
}

+ (NSString*)defaultReuseId{
    return @"XYAttendanceCell";
}

+ (CGFloat)defaultHeight{
    return 45;
}

@end
