//
//  XYVerifyCodeCell.m
//  XYMaintenance
//
//  Created by Kingnet on 16/10/9.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYVerifyCodeCell.h"
#import "XYConfig.h"

@implementation XYVerifyCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.verifyButton.titleLabel.textColor = THEME_COLOR;
    self.xyDetailField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (NSString*)defaultReustId{
    return @"XYVerifyCodeCell";
}

- (IBAction)verifyButtonClicked:(id)sender {
    if (self.didTapButton) {
        self.didTapButton(self.xyDetailField.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.didTapButton) {
        self.didTapButton(self.xyDetailField.text);
    }
}

@end
