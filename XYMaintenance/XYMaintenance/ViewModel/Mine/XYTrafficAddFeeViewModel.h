//
//  XYTrafficAddFeeViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/9/28.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

#define TFCNewRecordId @""

@protocol XYTrafficAddFeeCallBackDelegate <NSObject>
-(void)onFormerRecordsLoaded:(BOOL)isSuccess noteString:(NSString*)str;
-(void)onOperationsSubmitted:(BOOL)isSuccess noteString:(NSString*)str;
@end

@interface XYTrafficAddFeeViewModel : XYBaseViewModel
@property(assign,nonatomic)id<XYTrafficAddFeeCallBackDelegate> delegate;
@property(strong,nonatomic)NSMutableArray* editedRecordsArray;
@property(strong,nonatomic)NSMutableArray* recordsToAddArray;
@property(strong,nonatomic)NSMutableSet* recordsToEditArray;
@property(strong,nonatomic)NSMutableArray* recordsToDeleteArray;
@property(assign,nonatomic)CGFloat totalFee;

-(void)loadFormerRecords:(NSString*)date;

//单项内部的编辑 主要限定于显示
-(void)editLocOfIndexItem:(NSInteger)section into:(NSString*)str type:(BOOL)isStart;
-(void)editFeeOfIndexItem:(NSInteger)section into:(NSString*)str;

//增删项目的操作
-(void)addNewItem;
-(void)deleteItemOfIntex:(NSInteger)section;

//finally do as a whole... fuckkkkkk the design
-(void)submitEditedRecords:(NSString*)date;

@end
