//
//  XYPartApplicationCell.h
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "XYPartDto.h"

@interface XYPartApplicationCell : SWTableViewCell
@property (strong, nonatomic) XYPartsSelectionDto *partsSelection;
@end
