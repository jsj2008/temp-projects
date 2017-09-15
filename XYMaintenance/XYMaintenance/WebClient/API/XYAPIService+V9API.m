//
//  XYAPIService+V9API.m
//  XYMaintenance
//
//  Created by Kingnet on 17/1/3.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYAPIService+V9API.h"

static NSString* const PARTS_LOG = @"activities/parts-log";//配件流水
static NSString* const PARTS_SELECTION = @"repairprice/get-parts-info";//配件选项

@implementation XYAPIService (V9API)

- (NSInteger)getMyPartsFlowListFrom:(NSString*)searchStartTime to:(NSString*)searchEndTime part:(NSString*)part_id page:(NSInteger)page success:(void (^)(NSArray* partsList,NSInteger sum))success errorString:(void (^)(NSString *))errorString{
    
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:searchStartTime forKey:@"searchStartTime"];
    [parameters setValue:searchEndTime forKey:@"searchEndTime"];
    [parameters setValue:part_id forKey:@"part_id"];
    [parameters setValue:@(page) forKey:@"page"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PARTS_LOG parameters:parameters isPost:false success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        XYListDtoContainer* listDto = [XYListDtoContainer mj_objectWithKeyValues:dto.data];
        if (dto.code == RESPONSE_SUCCESS || dto.code == RESPONSE_NO_CONTENT){
            NSArray* array = [XYPartsLogDto mj_objectArrayWithKeyValuesArray:listDto.data];
            success(array,listDto.info.sum);
        }else{
            errorString(dto.mes);
        }
    } failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
    return requestId;
}

/**
 *  配件筛选项
 *
 *  @param mould_id 起始时间
 *  @param fault_id 终止时间
 *  @param color_id 颜色
 *
 *  @return requestId
 */
- (NSInteger)getPartsFlowSelectionsByDevice:(NSString*)mould_id fault:(NSString*)fault_id color:(NSString*)color_id success:(void (^)(NSArray* partsList))success errorString:(void (^)(NSString *))errorString{

    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:mould_id forKey:@"mould_id"];
    [parameters setValue:fault_id forKey:@"fault_id"];
    [parameters setValue:color_id forKey:@"color_id"];
    
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:PARTS_SELECTION parameters:parameters isPost:false success:^(id response){
        XYSingleArrayDto* dto = [XYSingleArrayDto mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            NSArray* featuresArray = [XYPartsSelectionDto mj_objectArrayWithKeyValuesArray:dto.data];
            success(featuresArray);
        }else{
            errorString(dto.mes);
        }
    }failure:^(NSString *error) {
        errorString?errorString(error):nil;
    }];
        return requestId;
}



@end
