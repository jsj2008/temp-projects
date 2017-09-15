//
//  XYEvaluationStarCountCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYEvaluationDto.h"
@interface XYEvaluationStarCountCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *starTitleLabel;
@property (nonatomic, strong) XYEvaluationDto *evaluationDto;
@end
