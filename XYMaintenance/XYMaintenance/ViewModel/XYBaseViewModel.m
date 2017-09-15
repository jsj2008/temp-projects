//
//  BaseViewModel.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYBaseViewModel.h"
#import "XYAPIService.h"

@interface XYBaseViewModel ()

@property(copy,nonatomic,readonly) NSMutableArray* requestArray;

@end

@implementation XYBaseViewModel

-(id)init
{
    if (self = [super init])
    {
        _requestArray = [[NSMutableArray alloc]init];
    }

    return self;
}

#pragma mark - management of requests

- (void)registerRequestId:(NSNumber*)requestId
{
    if(requestId)
    {
        [self.requestArray addObject:requestId];
    }
}

-(void)removeRequestId:(NSNumber *)requestId
{
    if(requestId)
    {
       [self.requestArray removeObject:requestId];
    }
}

-(void)cancelAllRequests
{
    for (NSNumber* requestId in self.requestArray)
    {
        [[XYAPIService shareInstance] cancelRequestWithId:requestId];
    }
}

-(void)dealloc
{
    TTDEBUGLOG(@"dealloc viewModel %@",[self class]);
}

@end
