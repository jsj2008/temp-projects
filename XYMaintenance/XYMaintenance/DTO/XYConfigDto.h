//
//  XYConfigDto.h
//  XYMaintenance
//
//  Created by lisd on 2017/4/6.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYConfigDto : NSObject<NSCoding>
@property(assign,nonatomic)BOOL location;
@property(assign,nonatomic)BOOL update_forced;
@property(assign,nonatomic)BOOL fastHotPatch;

@end
