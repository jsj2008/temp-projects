//
//  DYMonthlyCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/13.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYMonthlyCell : UICollectionViewCell
@property (strong, nonatomic) UILabel *monthLabel;
+(NSString*)defaultReuseId;

-(void)setTitle:(NSString*)title;

@end
