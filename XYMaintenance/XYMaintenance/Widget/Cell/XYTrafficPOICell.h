//
//  XYTrafficPOICell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/10/9.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYTrafficPOICell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *poiIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
+(CGFloat)defaultHeight;
+(NSString*)defaultReuseId;
@end
