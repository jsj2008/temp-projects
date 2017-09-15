//
//  XYEvaluationStarCountCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/5/2.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYEvaluationStarCountCell.h"

@interface XYEvaluationStarCountCell()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *starCountLabel;

@end

@implementation XYEvaluationStarCountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.trackTintColor = XY_HEX(0xe8e8e8);
    self.progressView.progressTintColor = XY_HEX(0xff5000);
    self.progressView.progress = 0.0;
}

-(void)setEvaluationDto:(XYEvaluationDto *)evaluationDto {
    _evaluationDto = evaluationDto;
    
    CGFloat progress= 0.0;
    CGFloat starCount = [self getStarCount:_evaluationDto.row];
    if (![_evaluationDto.user_comment_count floatValue]) {
        progress = 0.0;
    }else {
        progress =  starCount / [_evaluationDto.user_comment_count floatValue];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.progressView setProgress:progress animated:YES];
    });

    self.starCountLabel.text = [NSString stringWithFormat:@"%d", (int)starCount];
}

- (CGFloat)getStarCount:(NSInteger)row {
    CGFloat starCount = 0.0f;
    
    switch (row) {
        case 2:
            starCount = [_evaluationDto.five_star floatValue];
            break;
        case 3:
            starCount = [_evaluationDto.four_star floatValue];
            break;
        case 4:
            starCount = [_evaluationDto.three_star floatValue];
            break;
        case 5:
            starCount = [_evaluationDto.two_star floatValue];
            break;
        case 6:
            starCount = [_evaluationDto.one_star floatValue];
            break;
        
        default:
            break;
    }
    
    return starCount;
}
@end
