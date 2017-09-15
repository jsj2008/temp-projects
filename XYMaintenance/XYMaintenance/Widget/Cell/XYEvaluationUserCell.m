//
//  XYEvaluationUserCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYEvaluationUserCell.h"
#import "DYRateView.h"
@interface XYEvaluationUserCell()
@property (weak, nonatomic) IBOutlet DYRateView *rateView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCommentCountLabel;

@end

@implementation XYEvaluationUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.rateView.userInteractionEnabled = false;
}

- (void)setEvaluationDto:(XYEvaluationDto *)evaluationDto {
    _evaluationDto = evaluationDto;
    
    self.starCountLabel.text = _evaluationDto.eng_counts;
    self.userCommentCountLabel.text = _evaluationDto.user_comment_count;
    self.rateView.rate = [evaluationDto.eng_counts floatValue];
}

@end
