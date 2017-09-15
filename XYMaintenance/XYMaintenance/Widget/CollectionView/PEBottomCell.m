//
//  PEBottomCell.m
//  XYHiRepairs
//
//  Created by wuw on 16/5/18.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "PEBottomCell.h"
@interface PEBottomCell()
- (IBAction)evaluationAction:(id)sender;

@end

@implementation PEBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (IBAction)evaluationAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickEvaluationButton)]) {
        [self.delegate didClickEvaluationButton];
    }
}
@end
