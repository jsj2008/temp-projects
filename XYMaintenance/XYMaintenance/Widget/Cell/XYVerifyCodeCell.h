//
//  XYVerifyCodeCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/10/9.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYVerifyCodeCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *xyTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *xyDetailField;
@property (weak, nonatomic) IBOutlet UIButton *verifyButton;
@property (copy, nonatomic) void (^didTapButton)(NSString* text);
+ (NSString*)defaultReustId;
@end
