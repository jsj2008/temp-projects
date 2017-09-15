//
//  XYPartApplicationViewModel.m
//  XYMaintenance
//
//  Created by lisd on 2017/3/14.
//  Copyright © 2017年 Kingnet. All rights reserved.
//

#import "XYPartApplicationViewModel.h"

@interface XYPartApplicationViewModel()

@end

@implementation XYPartApplicationViewModel

-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (void)loadPartAmountData{
    [[XYAPIService shareInstance] getPartAmountSuccess:^(XYPartsAmountDto *partsAmountDto) {
        if ([self.delegate respondsToSelector:@selector(onPartAmountLoaded:partsAmountDto:noteString:)]){
            [self.delegate onPartAmountLoaded:YES partsAmountDto:partsAmountDto noteString:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onPartAmountLoaded:partsAmountDto:noteString:)]){
            [self.delegate onPartAmountLoaded:NO partsAmountDto:nil noteString:error];
        }
    }];
}

@end
