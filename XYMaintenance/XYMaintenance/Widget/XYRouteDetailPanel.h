//
//  XYRouteDetailPanel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XYRouteDetailPanel : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *walkingLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (assign,nonatomic) BOOL isFolded;

-(CGFloat)foldedHeight;

-(CGFloat)totalHeight;



@end
