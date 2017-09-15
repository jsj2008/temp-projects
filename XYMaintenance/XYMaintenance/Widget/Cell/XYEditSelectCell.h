//
//  XYEditSelectCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/21.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XYEditSelectCellType){
    XYEditSelectCellTypeInvalid= -1,
    XYEditSelectCellTypeDevice = 0, //机型
    XYEditSelectCellTypeColor = 1, //颜色
    XYEditSelectCellTypeFault = 2, //故障
    XYEditSelectCellTypePlan = 3,    //维修方案
    XYEditSelectCellTypePartSource = 4, //配件来源
};

@interface XYEditSelectCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *xyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *xyContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

+ (NSString*)defaultReuseId;

@end
