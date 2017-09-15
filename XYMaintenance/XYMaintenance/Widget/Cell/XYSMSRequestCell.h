//
//  XYSMSRequestCell.h
//  XYMaintenance
//
//  Created by Kingnet on 16/11/21.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCountDownButton.h"
#import "XYSimpleTextField.h"

@interface XYSMSRequestCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabelView;
@property (weak, nonatomic) IBOutlet XYCountDownButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet XYSimpleTextField *xyTextField;
+ (NSString*)defaultReuseId;
@end
