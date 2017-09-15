//
//  XYIncompleteOrderCell.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "DTO.h"

@interface XYIncompleteOrderCell : SWTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *phoneCallButton;
@property(retain,nonatomic,readonly)NSArray* rightButtonsArray;

+ (CGFloat)getHeight;
+ (NSString*)defaultIdentifier;

- (void)setAllTypeOrder:(XYAllTypeOrderDto*)data;

@end
