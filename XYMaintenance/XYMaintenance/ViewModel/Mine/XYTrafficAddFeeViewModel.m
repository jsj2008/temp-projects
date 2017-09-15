//
//  XYTrafficAddFeeViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYTrafficAddFeeViewModel.h"
#import "MJExtension.h"

@implementation XYTrafficAddFeeViewModel

#pragma mark - containers

-(NSMutableArray*)editedRecordsArray{
    if (!_editedRecordsArray) {
        _editedRecordsArray = [[NSMutableArray alloc]init];
    }
    return _editedRecordsArray;
}

-(NSMutableArray*)recordsToAddArray{
    if (!_recordsToAddArray) {
        _recordsToAddArray = [[NSMutableArray alloc]init];
    }
    return _recordsToAddArray;
}

-(NSMutableSet*)recordsToEditArray{
    if (!_recordsToEditArray) {
        _recordsToEditArray = [[NSMutableSet alloc]init];
    }
    return _recordsToEditArray;
}

-(NSMutableArray*)recordsToDeleteArray{
    if (!_recordsToDeleteArray) {
        _recordsToDeleteArray = [[NSMutableArray alloc]init];
    }
    return _recordsToDeleteArray;
}

#pragma mark - show

-(CGFloat)totalFee{
    
    CGFloat total = 0;
    @try {
        for (XYTrafficRecordDto* dto in self.editedRecordsArray) {
            total += [dto.fare floatValue];
        }
    }
    @catch (NSException *exception) {}
    
    return total;
}

-(void)loadFormerRecords:(NSString*)date{
    
   NSInteger requestId = [[XYAPIService shareInstance]getTFCDailyRouteOf:date success:^(NSArray *info) {
       [self.editedRecordsArray removeAllObjects];
       if (info) {
           [self.editedRecordsArray addObjectsFromArray:info];
       }
       if ([self.delegate respondsToSelector:@selector(onFormerRecordsLoaded:noteString:)]) {
           [self.delegate onFormerRecordsLoaded:true noteString:nil];
       }
   } errorString:^(NSString *error) {
       if ([self.delegate respondsToSelector:@selector(onFormerRecordsLoaded:noteString:)]) {
           [self.delegate onFormerRecordsLoaded:false noteString:error];
       }
   }];
    
   [self registerRequestId:@(requestId)];
}

#pragma mark - edit

-(void)editLocOfIndexItem:(NSInteger)section into:(NSString*)str type:(BOOL)isStart
{
    if (section >= [self.editedRecordsArray count]) {
        return;
    }
    
    XYTrafficRecordDto* dto = [self.editedRecordsArray objectAtIndex:section];
    if (isStart) {
        dto.start_point = str;
    }else{
        dto.end_point = str;
    }
    
    if (![dto.id isEqualToString:TFCNewRecordId]) {
        [self markEditedItem:dto.id];
    }
}

-(void)editFeeOfIndexItem:(NSInteger)section into:(NSString*)str
{
    if (section >= [self.editedRecordsArray count]) {
        return;
    }
    
    XYTrafficRecordDto* dto = [self.editedRecordsArray objectAtIndex:section];
    dto.fare = [str hasPrefix:@"￥"]?[str substringFromIndex:1]:str;
    
    if (![dto.id isEqualToString:TFCNewRecordId]) {
        [self markEditedItem:dto.id];
    }
}

-(void)markEditedItem:(NSString*)editedId
{
    [self.recordsToEditArray addObject:editedId];
}

-(void)addNewItem
{
    XYTrafficRecordDto* dto = [[XYTrafficRecordDto alloc]init];
    dto.id = TFCNewRecordId;
    dto.start_point = @"";
    dto.end_point=@"";
    dto.fare = @"";
    [self.editedRecordsArray addObject:dto];
}

//删除操作的记录，，、、每个都记一下，，  没有原始记录的传 ""
-(void)deleteItemOfIntex:(NSInteger)section
{
    if (section >= [self.editedRecordsArray count]) {
        return;
    }
    
    XYTrafficRecordDto* dto = [self.editedRecordsArray objectAtIndex:section];
    
    if (![dto.id isEqualToString:TFCNewRecordId]) {
         dto.operate = @"delete";
        [self.recordsToDeleteArray addObject:dto];
    }
    
    [self.editedRecordsArray removeObject:dto];
}

#pragma mark - submit


-(void)submitEditedRecords:(NSString*)date
{
    [self.recordsToAddArray removeAllObjects];
    
    for (NSInteger i = 0;  i < [self.editedRecordsArray count]; i ++)
    {
        XYTrafficRecordDto* dto = [self.editedRecordsArray objectAtIndex:i];
        if ([dto.id isEqualToString:TFCNewRecordId]){
            dto.operate = @"add";
            [self.recordsToAddArray addObject:dto];
        }
        else
        {
            for (NSString* str in self.recordsToEditArray)
            {
                if ([str isEqualToString:dto.id])
                {
                    dto.operate = @"update";
                    [self.recordsToAddArray addObject:dto];
                    break;
                }
            }
        }
    }
    
    [self doTransation:date];
}

-(void)doTransation:(NSString*)date{

    NSMutableArray* array = [[NSMutableArray alloc]init];
    
    for (XYTrafficRecordDto* dto in self.recordsToAddArray) {
        [array addObject:[dto mj_keyValues]];
    }
    
    for (XYTrafficRecordDto* dto in self.recordsToDeleteArray) {
        [array addObject:[dto mj_keyValues]];
    }
      
    if([array count]==0)
    {
        if ([self.delegate respondsToSelector:@selector(onOperationsSubmitted:noteString:)]) {
            [self.delegate onOperationsSubmitted:true noteString:nil];
        }
        return;
    }
    

   NSInteger requestId = [[XYAPIService shareInstance]postEditedDailyRoutesRecord:date body:array success:^{
       if ([self.delegate respondsToSelector:@selector(onOperationsSubmitted:noteString:)]) {
           [self.delegate onOperationsSubmitted:true noteString:nil];
       }
    } errorString:^(NSString *e) {
        if ([self.delegate respondsToSelector:@selector(onOperationsSubmitted:noteString:)]) {
            [self.delegate onOperationsSubmitted:false noteString:e];
        }
    }];
    
    [self registerRequestId:@(requestId)];
    

   
}






@end
