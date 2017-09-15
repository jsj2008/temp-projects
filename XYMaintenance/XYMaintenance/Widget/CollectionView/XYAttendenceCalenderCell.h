//
//  XYAttendenceCalenderCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/9/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYAttendenceCalenderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *absenceLabel;

+ (NSString*)defaultReuseId;

- (void)setTitle:(NSString*)titleStr;
- (void)setDate:(NSInteger)date isThisMonth:(BOOL)thisMonth isAbsence:(BOOL)absence isLeave:(BOOL)isLeave isSelected:(BOOL)selected;

@end
