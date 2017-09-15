//
//  XYOtherFaultsCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYOtherFaultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UIImageView *faultIndicatorView;

+ (NSString*)defaultReuseId;

- (void)setFaultSelected:(BOOL)selected;

@end
