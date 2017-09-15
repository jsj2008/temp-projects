//
//  XYPartApplicationSubmitView.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplicationSubmitView.h"

@interface XYPartApplicationSubmitView()
@property (weak, nonatomic) IBOutlet UIView *buttonBackgroundView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation XYPartApplicationSubmitView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYPartApplicationSubmitView" owner:self options:nil] objectAtIndex:0];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, 60);
    self.buttonBackgroundView.layer.masksToBounds = YES;
    self.buttonBackgroundView.layer.cornerRadius = 20;
    //总额：¥2000
    return self;
}

- (IBAction)submit:(id)sender {
    if ([self.delegate respondsToSelector:@selector(onSubmitButtonClicked)]) {
        [self.delegate onSubmitButtonClicked];
    }
}

@end
