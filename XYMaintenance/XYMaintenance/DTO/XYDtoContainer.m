//
//  XYDtoContainer.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/29.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYDtoContainer.h"


@implementation XYDtoContainer

/**
 *  dto的三种message参数名。。。
 */
- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        if (self.msg) {
            return self.msg;
        }else{
            return self.message;
        }
    }
}

@end

@implementation XYBoolDto
@end

@implementation XYStringDto
@end

@implementation XYInfoDto
@end

@implementation XYListDtoContainer
/**
 *  dto的三种message参数名。。。
 */
- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        if (self.msg) {
            return self.msg;
        }else{
            return self.message;
        }
    }
}
@end

@implementation XYSingleArrayDto
/**
 *  dto的三种message参数名。。。
 */
- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        if (self.msg) {
            return self.msg;
        }else{
            return self.message;
        }
    }
}
@end

@implementation XYSingleIntegerDto
/**
 *  dto的三种message参数名。。。
 */
- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        if (self.msg) {
            return self.msg;
        }else{
            return self.message;
        }
    }
}
@end

@implementation XYPageListDtoContainer

- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        return self.msg;
    }
}
@end

@implementation XYMultiplePageListDtoContainer

- (NSString*)mes{
    if (_mes) {
        return _mes;
    }else{
        return self.msg;
    }
}
@end


