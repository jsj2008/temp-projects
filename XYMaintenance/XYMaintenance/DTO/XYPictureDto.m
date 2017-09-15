//
//  XYPictureDto.m
//  XYMaintenance
//
//  Created by Kingnet on 16/11/1.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYPictureDto.h"
#import "MJExtension.h"
#import "XYConfig.h"

@implementation XYPictureDto

+ (NSString*)jsonStringWithOrderId:(NSString*)orderId url:(NSString*)url bid:(XYBrandType)bid type:(XYPictureType)type name:(NSString*)name{
    XYPictureDto* dto = [[XYPictureDto alloc]init];
    dto.orderId = orderId;
    dto.assetUrl = url;
    dto.bid = bid;
    dto.type = type;
    dto.name = name;
    return [dto mj_JSONString]?[dto mj_JSONString]:@"";
}

+ (NSString*)keyWithOrderId:(NSString*)orderId bid:(XYBrandType)bid type:(XYPictureType)type name:(NSString*)name{
    return [NSString stringWithFormat:@"%@,%@,%@,%@",@(bid),orderId,@(type),name];
}

+ (XYPictureDto*)dtoFromJsonString:(NSString*)str{
    XYPictureDto* result = nil;
    @try {
        result =  [XYPictureDto mj_objectWithKeyValues:str];
    } @catch (NSException *exception) {
        TTDEBUGLOG(@"exception = %@",exception);
    } @finally {
        return result;
    }
}

@end
