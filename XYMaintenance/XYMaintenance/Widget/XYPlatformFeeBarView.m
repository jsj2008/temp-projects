//
//  XYPlatformFeeBarView.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/5.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPlatformFeeBarView.h"

@interface XYPlatformFeeBarView()

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation XYPlatformFeeBarView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYPlatformFeeBarView" owner:self options:nil] objectAtIndex:0];
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 18;
}

- (IBAction)submit:(id)sender {
    !_submitFeeBlock ?: _submitFeeBlock();
}

@end
