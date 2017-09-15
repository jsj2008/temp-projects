//
//  XYAttendanceDetailView.h
//  XYMaintenance
//
//  Created by Kingnet on 16/9/19.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYAttendanceDto.h"

@interface XYAttendanceDetailView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;

+ (NSString*)defaultReuseId;
- (void)setAttendanceData:(XYAttendanceDto*)data;

@end
