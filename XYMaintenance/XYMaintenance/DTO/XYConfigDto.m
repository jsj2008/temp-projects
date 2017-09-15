//
//  XYConfigDto.m
//  XYMaintenance
//
//  Created by lisd on 2017/4/6.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYConfigDto.h"

@implementation XYConfigDto
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:_location forKey:@"location"];
    [aCoder encodeBool:_location forKey:@"update_forced"];
    [aCoder encodeBool:_fastHotPatch forKey:@"fastHotPatch"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _location = [aDecoder decodeBoolForKey:@"location"];
        _update_forced = [aDecoder decodeBoolForKey:@"update_forced"];
        _fastHotPatch = [aDecoder decodeBoolForKey:@"fastHotPatch"];
    }
    return self;
}
@end
