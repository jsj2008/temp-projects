//
//  UITableViewCell+XYTableViewRegister.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "UITableViewCell+XYTableViewRegister.h"

@implementation UITableViewCell (XYTableViewRegister)

+(void)xy_registerTableView:(UITableView*)tableView identifier:(NSString*)identifier{
    NSString *className = NSStringFromClass([self class]);
    UINib *nib = [UINib nibWithNibName:className bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:identifier];
}

@end
