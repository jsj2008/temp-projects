//
//  XYUserDetail.m
//  XYMaintenance
//
//  Created by Kingnet on 16/5/30.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYUserDetail.h"



@implementation XYUserDto
@end

@implementation XYUserLevelInfo

@end

@implementation XYUserDetail
- (NSString*)townsString{
    if (!_townsString) {
        if (self.town && [self.town allKeys].count > 0) {
            NSMutableString* townStr = [[NSMutableString alloc]init];
            for (NSString* key in [self.town allKeys]) {
                [townStr appendString:key];
                NSArray* array = self.town[key];
                if (array) {
                    [townStr appendString:@"("];
                    for (NSString* subTown in array) {
                        [townStr appendFormat:@"%@、",subTown];
                    }
                    [townStr appendString:@")"];
                }
                if ([[townStr substringWithRange:NSMakeRange(townStr.length-2, 1)] isEqualToString:@"、"]) {
                    [townStr deleteCharactersInRange:NSMakeRange(townStr.length-2, 1)];
                }
                [townStr appendString:@"、"];
            }
            if([townStr hasSuffix:@"、"]){
                _townsString = [townStr substringToIndex:townStr.length-1];
            }else{
                _townsString = townStr;
            }
        }else{
            _townsString = @"无";
        }
    }
    return _townsString;
}
@end
