//
//  XYPayDto.m
//  XYMaintenance
//
//  Created by Kingnet on 17/2/4.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPayDto.h"
#import "MJExtension.h"
#import "XYConfig.h"
#import "XYAPPSingleton.h"

@implementation XYFeatureDto

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_node_name forKey:@"node_name"];
    [aCoder encodeObject:@(_is_open) forKey:@"is_open"];
    [aCoder encodeObject:@(_brandid) forKey:@"brandid"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _node_name = [aDecoder decodeObjectForKey:@"node_name"];
        _is_open = [[aDecoder decodeObjectForKey:@"is_open"] boolValue];
        _brandid = [[aDecoder decodeObjectForKey:@"brandid"] integerValue];
    }
    return self;
}

+ (NSString *)savePath{
    NSString *docPath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSString *path=[docPath stringByAppendingPathComponent:[NSString stringWithFormat:@"XYFeatureDto_%@",[XYAPPSingleton sharedInstance].currentUser.Id]];
    return path;
}

+ (void)save:(NSArray<XYFeatureDto*>*)features
{
    [NSKeyedArchiver archiveRootObject:features toFile:[self savePath]];
}

+ (NSArray<XYFeatureDto*>*)loadFeatures{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self savePath]];
}


@end

@implementation XYPayOpenModel

- (void)initWithAllFalse{
    self.cashpay = false;
    self.qrcode = false;
    self.qrcodealipay = false;
    self.anotherpayalipay = false;
    self.anotherpayweixin = false;
}

+ (XYPayOpenModel*)modelWithAllFalse{
    XYPayOpenModel* model = [[XYPayOpenModel alloc]init];
    [model initWithAllFalse];//默认全部guanbi
    return model;
}

+ (NSDictionary<NSString*,XYPayOpenModel*>*)convert:(NSArray<XYFeatureDto*>*)features{
    
    if (!features) {
        return nil;
    }
    
    NSMutableDictionary* featureMap = [[NSMutableDictionary alloc]init];
    for(XYFeatureDto* feature in features){
        XYBrandType bid = feature.brandid;
        NSString* key = [NSString stringWithFormat:@"%@",@(bid)];
        XYPayOpenModel* model = [XYPayOpenModel modelWithAllFalse];
        model.bid = bid;
        if (featureMap[key] == nil) {
            [featureMap setObject:model forKey:key];
        }else{
            model = featureMap[key];
        }
        if ([feature.node_name isEqualToString:@"cash-pay"]) {
            model.cashpay = (feature.is_open == XYFeatureStatusOpen);
        }else if ([feature.node_name isEqualToString:@"qrcode"]) {
            model.qrcode = (feature.is_open == XYFeatureStatusOpen);
        }else if ([feature.node_name isEqualToString:@"qrcodealipay"]) {
            model.qrcodealipay = (feature.is_open == XYFeatureStatusOpen);
        }else if ([feature.node_name isEqualToString:@"anotherpayweixin"]) {
            model.anotherpayweixin = (feature.is_open == XYFeatureStatusOpen);
        }else if ([feature.node_name isEqualToString:@"anotherpayalipay"]) {
            model.anotherpayalipay = (feature.is_open == XYFeatureStatusOpen);
        }else {
            //
        }
        [featureMap setObject:model forKey:key];
    }
    TTDEBUGLOG(@"featureMap = %@",[featureMap mj_keyValues]);
    return featureMap;
}

@end
