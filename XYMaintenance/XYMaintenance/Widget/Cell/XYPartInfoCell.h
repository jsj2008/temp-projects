//
//  XYPartInfoCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYPartInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *partNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partIdLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deviderHeight;
+(CGFloat)getHeight;
+(NSString*)defaultIdentifier;
@end
