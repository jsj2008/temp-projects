//
//  XYPlatformFeeCell.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/5.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPlatformFeeCell.h"

static NSString *const XYPlatformFeeCellIdentifier = @"XYPlatformFeeCellIdentifier";

@implementation XYPlatformFeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString*)defaultReuseId{
    return XYPlatformFeeCellIdentifier;
}

@end
