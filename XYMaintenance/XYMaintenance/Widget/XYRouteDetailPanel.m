//
//  XYRouteDetailPanel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYRouteDetailPanel.h"
#import "XYConfig.h"
#import "XYWidgetUtil.h"

@implementation XYRouteDetailPanel

- (id)init{
    
    self = [[[NSBundle mainBundle] loadNibNamed:@"XYRouteDetailPanel" owner:self options:nil] objectAtIndex:0];
    if (self) {
        [self initializeUI];
    }
    
    return self;
}

- (void)initializeUI{
 
    self.isFolded = false;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView setTableFooterView:[XYWidgetUtil getSingleLine]];
    self.layer.shadowOffset = CGSizeMake(0, -7);
    self.layer.shadowColor = LIGHT_TEXT_COLOR.CGColor;
    self.layer.shadowOpacity = 0.2;
    }

- (CGFloat)foldedHeight{
    return 63;
}

- (CGFloat)totalHeight{
    return SCREEN_HEIGHT/2;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
