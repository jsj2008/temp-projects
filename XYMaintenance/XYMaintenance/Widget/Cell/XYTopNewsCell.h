//
//  XYTopNewsCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 16/3/3.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYTopNewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

+ (NSString*)defaultReuseId;
+ (CGFloat)defaultHeight;

- (void)setContent:(NSString*)title;

@end
