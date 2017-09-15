//
//  XYContactViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/7/31.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYContactViewModel.h"

@implementation XYContactViewModel

- (id)init{
    
    if (self = [super init]){
        _sectionTitleArray = [[NSArray alloc]init];
        _contactsDictionary = [[NSDictionary alloc]init];
    }
    return self;
}

- (void)loadContactsList{


}


- (NSString*)servicePhone{
    return SERVICE_PHONE;
}


- (void)generateTitles{
    
    NSMutableArray* titleArray = [[NSMutableArray alloc]init];
    [titleArray addObjectsFromArray:[self.contactsDictionary allKeys]];
    _sectionTitleArray = [titleArray sortedArrayUsingComparator:^NSComparisonResult(NSString *key1, NSString *key2) {
        return [key1 compare: key2];
    }];
}

@end
