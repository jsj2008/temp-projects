//
//  XYPartApplicationViewModel.h
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartDto.h"
#import "XYBaseViewModel.h"

@protocol XYPartApplicationBackDelegate <NSObject>

- (void)onPartAmountLoaded:(BOOL)success partsAmountDto:(XYPartsAmountDto*)partsAmountDto noteString:(NSString*)noteString;

@end

@interface XYPartApplicationViewModel :XYBaseViewModel

@property (nonatomic, strong) NSMutableArray *dataArr;
@property(assign,nonatomic)id<XYPartApplicationBackDelegate> delegate;
- (void)loadPartAmountData;

@end
