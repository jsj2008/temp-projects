//
//  XYPartClaimCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/23.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYCustomButton.h"
#import "XYPartDto.h"

@interface XYPartClaimCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet XYCustomButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIView *deviderLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;

+ (CGFloat)getHeight:(BOOL)folded;
+ (NSString*)defaultIdentifier;
- (void)setData:(XYPartRecordDto*)data;
@end
