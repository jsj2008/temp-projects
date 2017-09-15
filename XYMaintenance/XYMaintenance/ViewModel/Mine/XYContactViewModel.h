//
//  XYContactViewModel.h
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"

@protocol XYContactCallBackDelegate <NSObject>

-(void)onContactsListLoaded:(BOOL)success noteString:(NSString*)str;

@end

@interface XYContactViewModel : XYBaseViewModel

@property(retain,nonatomic,readonly) NSArray *sectionTitleArray;
@property(retain,nonatomic,readonly) NSDictionary* contactsDictionary;
@property(assign,nonatomic) id<XYContactCallBackDelegate> delegate;

@property(copy,nonatomic,readonly) NSString* servicePhone;

-(void)loadContactsList;

@end
