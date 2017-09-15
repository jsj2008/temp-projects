//
//  UITableViewCell+XYTableViewRegister.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XYTableViewRegister)
+(void)xy_registerTableView:(UITableView*)tableView identifier:(NSString*)identifier;
@end
