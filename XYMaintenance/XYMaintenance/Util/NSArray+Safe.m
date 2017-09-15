//
//  NSArray+Safe.m
//  XYMaintenance
//
//  Created by lisd on 2017/7/29.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "NSArray+Safe.h"

@implementation NSArray (Safe)
- (id)objectAt:(NSUInteger)index
{
    if (index < self.count)
    {
        return self[index];
    }
    else
    {
        return nil;
    }
}
@end
