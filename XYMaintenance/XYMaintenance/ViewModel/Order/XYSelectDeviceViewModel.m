//
//  XYSelectDeviceViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/18.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSelectDeviceViewModel.h"
#import "XYStringUtil.h"

@implementation XYSelectDeviceViewModel

#pragma mark - property

- (NSMutableDictionary*)deviceMap{
    if (!_deviceMap) {
        _deviceMap = [[NSMutableDictionary alloc]init];
    }
    return _deviceMap;
}

- (NSArray*)brandsArray{
    if (!_brandsArray) {
        _brandsArray = [[NSArray alloc]init];
    }
    return _brandsArray;
}

- (NSMutableArray*)itemsArray{
    if (!_itemsArray) {
        _itemsArray = [[NSMutableArray alloc]init];
    }
    return _itemsArray;
}

#pragma mark - method

- (XYSelectDeviceType)getTypeByProductName:(NSString*)proName{
    if ([proName isEqualToString:@"手机"]) {
        return XYSelectDeviceTypePhone;
    }else if ([proName isEqualToString:@"平板"]) {
        return XYSelectDeviceTypePad;
    }
    return XYSelectDeviceTypeUnknown;
}

- (void)updateDevicesByBrandIndex:(NSInteger)brandIndex andType:(XYSelectDeviceType)type{
    [self.itemsArray removeAllObjects];
    if (brandIndex >= 0 && brandIndex < self.brandsArray.count) {
        NSString* brandName = self.brandsArray[brandIndex];
        for (NSString* key in [self.deviceMap allKeys]) {
            NSArray* array = self.deviceMap[key];
            for (XYPHPDeviceDto* dto in array) {
                if ([key isEqualToString:brandName] && ([self getTypeByProductName:dto.ProductName] == type)) {
                    [self.itemsArray addObject:dto];
                }
            }
        }
    }
    return;
}

- (void)getAllDevices:(XYOrderDeviceType)type success:(void (^)())success errorString:(void (^)(NSString *))error{
   [[XYAPIService shareInstance] getAllDevicesType:type success:^(NSDictionary *deviceDic){
       self.deviceMap = [[NSMutableDictionary alloc]initWithDictionary:deviceDic];
       //生成品牌名列表
       NSMutableDictionary* brandsMap = [[NSMutableDictionary alloc]init];
       for (NSString* key in [self.deviceMap allKeys]) {
           NSArray* array = self.deviceMap[key];
           if ((!array)||array.count > 0) {
               XYPHPDeviceDto* dto = array[0];
               [brandsMap setValue:dto.BrandId forKey:key];
           }
       }
       self.brandsArray = [[brandsMap allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           return [brandsMap[obj1] compare:brandsMap[obj2]];
       }];
       success();
   }errorString:^(NSString *e){
       error(e);
   }];
}

//- (void)sortKeys:(NSDictionary*)dic{
//    
//    NSMutableDictionary* brandsMap = [[NSMutableDictionary alloc]init];
//    for (NSString* key in [dic allKeys]) {
//        NSArray* array = dic[key];
//        if ((!array)||array.count > 0) {
//            XYPHPDeviceDto* dto = array[0];
//            if([XYStringUtil isNullOrEmpty:self.brandId]){
//               [brandsMap setValue:dto.BrandId forKey:key];
//            }else{//如果有指定的品牌
//                if ([dto.BrandId isEqualToString:self.brandId]) {
//                    [brandsMap setValue:dto.BrandId forKey:key];
//                }else{
//                    [brandsMap setValue:nil forKey:key];
//                }
//            }
//        }
//    }
//    
//    [self.deviceDic removeAllObjects];
//    for (NSString* key in [dic allKeys]) {
//        if (brandsMap[key] != nil) {
//            [self.deviceDic setObject:dic[key] forKey:key];
//        }
//    }
//    
//    self.titleArray = [[self.deviceDic allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
//        return [brandsMap[key1] compare:brandsMap[key2]];
//    }];
//}
//
//- (void)generateSectionIndexs{
//    
//    NSMutableArray* secMutableArray = [[NSMutableArray alloc]init];
//    NSMutableArray* secIndexMutableArray = [[NSMutableArray alloc]init];
//    
//    for (NSInteger i = 0; i < [self.titleArray count]; i++){
//        NSString* str = [self.titleArray objectAtIndex:i];
//        for (NSInteger j = 0; j < [str length]; j ++) {
//            [secMutableArray addObject:[NSString stringWithFormat:@"  %@  ",[str substringWithRange:NSMakeRange(j, 1)]]];
//            [secIndexMutableArray addObject:@(i)];
//        }
//        for (NSInteger k = 0; k < 3; k ++)
//        {
//            [secMutableArray addObject:@""];
//            [secIndexMutableArray addObject:@(-1)];
//        }
//    }
//    self.sectionTitlesArray = secMutableArray;
//    self.sectionIndexesArray = secIndexMutableArray;
//}

@end
