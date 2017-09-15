//
//  XYAttendanceDetailView.m
//  XYMaintenance
//
//  Created by Kingnet on 16/9/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYAttendanceDetailView.h"
#import "XYStringUtil.h"

@implementation XYAttendanceDetailView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (NSString*)defaultReuseId{
    return @"XYAttendanceDetailView";
}

- (void)setAttendanceData:(XYAttendanceDto*)data{
    
    if (!data) {
        self.leftDetailLabel.text = @"首打卡：--:--";
        self.rightDetailLabel.text = @"末打卡：--:--";
        return;
    }
    
    if (data.online_at > 0.5) {
        //有上班时间的 一律显示为上班
        self.leftDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"首打卡：%@",data.onlineStr] lightRange:data.onlineStr lightColor:BLACK_COLOR];
        if (data.offline_at < 0.5) {
            self.rightDetailLabel.text = [NSString stringWithFormat:@"末打卡：%@",data.offlineStr];
        }else{
            self.rightDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"末打卡：%@",data.offlineStr] lightRange:data.offlineStr lightColor:BLACK_COLOR];
        }
    }else{
        switch (data.status) {
            case XYAttendenceTypeWorking:
            {
                if (data.online_at < 0.5) {
                    self.leftDetailLabel.text = [NSString stringWithFormat:@"首打卡：%@",data.onlineStr];
                }else{
                    self.leftDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString: [NSString stringWithFormat:@"首打卡：%@",data.onlineStr] lightRange:data.onlineStr lightColor:BLACK_COLOR];
                }
                if (data.offline_at < 0.5) {
                    self.rightDetailLabel.text = [NSString stringWithFormat:@"末打卡：%@",data.offlineStr];
                }else{
                    self.rightDetailLabel.attributedText = [XYStringUtil getAttributedStringFromString:[NSString stringWithFormat:@"末打卡：%@",data.offlineStr] lightRange:data.offlineStr lightColor:BLACK_COLOR];
                }
            }
                break;
            case XYAttendenceTypeAbsence:
            case XYAttendenceTypeHoliday:
            {
                if(data.leave_status == XYLeaveReviewTypeApproved){//请假审核通过
                    //用请假状态判断请没过请假。。。猜的
                    self.leftDetailLabel.text = [NSString stringWithFormat:@"请假类型：%@",data.leaveTypeStr];
                    self.rightDetailLabel.text = [NSString stringWithFormat:@"时间：%@",data.create_at];
                }else{
                    self.leftDetailLabel.text = @"首打卡：--:--";
                    self.rightDetailLabel.text = @"末打卡：--:--";
                }
            }
                break;
            default:
                break;
        }
    }
}

@end
