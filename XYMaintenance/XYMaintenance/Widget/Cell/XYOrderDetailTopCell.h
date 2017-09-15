//
//  XYOrderDetailTopCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYOrderDetailTopCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
+(NSString*)defaultReuseId;
@end
