//
//  BackgroundTaskManager.m
//
//  Created by Puru Shukla on 20/02/13.
//  Copyright (c) 2013 Puru Shukla. All rights reserved.
//

#import "BackgroundTaskManager.h"
#import "XYConfig.h"

@interface BackgroundTaskManager()
@property (nonatomic, strong) NSMutableArray* bgTaskIdList;
@property (assign) UIBackgroundTaskIdentifier masterTaskId;
@end

@implementation BackgroundTaskManager

+ (instancetype)sharedBackgroundTaskManager{
    static BackgroundTaskManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[BackgroundTaskManager alloc] init];
    });
    return sharedBGTaskManager;
}

- (id)init{
    if(self = [super init]){
        _bgTaskIdList = [NSMutableArray array];
        _masterTaskId = UIBackgroundTaskInvalid;
    }
    return self;
}

-(UIBackgroundTaskIdentifier)beginNewBackgroundTask{
    
    UIApplication* application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTaskId = UIBackgroundTaskInvalid;
    if([application respondsToSelector:@selector(beginBackgroundTaskWithExpirationHandler:)])
    {
        bgTaskId = [application beginBackgroundTaskWithExpirationHandler:^{
            TTDEBUGLOG(@"background task %lu expired", (unsigned long)bgTaskId);
        }];
        
        if ( self.masterTaskId == UIBackgroundTaskInvalid )
        {
            self.masterTaskId = bgTaskId;
            TTDEBUGLOG(@"started master task %lu", (unsigned long)self.masterTaskId);
        }
        else
        {
            //add this id to our list
            TTDEBUGLOG(@"started background task %lu", (unsigned long)bgTaskId);
            [self.bgTaskIdList addObject:@(bgTaskId)];
            [self endBackgroundTasks];
        }
    }
    
    return bgTaskId;
}

-(void)endBackgroundTasks
{
    [self drainBGTaskList:NO];
}

-(void)endAllBackgroundTasks
{
    [self drainBGTaskList:YES];
}

-(void)drainBGTaskList:(BOOL)all
{
    //mark end of each of our background task
    UIApplication* application = [UIApplication sharedApplication];
    if([application respondsToSelector:@selector(endBackgroundTask:)]){
        
        NSUInteger count=self.bgTaskIdList.count;
        for ( NSUInteger i=(all?0:1); i<count; i++ )
        {
            UIBackgroundTaskIdentifier bgTaskId = [[self.bgTaskIdList objectAtIndex:0] integerValue];
            TTDEBUGLOG(@"ending background task with id -%lu", (unsigned long)bgTaskId);
            [application endBackgroundTask:bgTaskId];
            [self.bgTaskIdList removeObjectAtIndex:0];
        }
        if ( self.bgTaskIdList.count > 0 )
        {
            TTDEBUGLOG(@"kept background task id %@", [self.bgTaskIdList objectAtIndex:0]);
        }
        if ( all )
        {
            TTDEBUGLOG(@"no more background tasks running");
            [application endBackgroundTask:self.masterTaskId];
            self.masterTaskId = UIBackgroundTaskInvalid;
        }
        else
        {
            TTDEBUGLOG(@"kept master background task id %lu", (unsigned long)self.masterTaskId);
        }
    }
}


@end
