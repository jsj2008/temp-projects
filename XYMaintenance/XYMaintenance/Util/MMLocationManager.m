//
//  MMLocationManager.m
//  DemoBackgroundLocationUpdate
//
//  Created by Ralph Li on 7/20/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//

#import "MMLocationManager.h"

#import "XYAPIService.h"


@interface MMLocationManager()
<
CLLocationManagerDelegate
>

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;


@property (strong, nonatomic) NSFileManager* fileManager;
@property (strong, nonatomic) NSString* filePath;

@end

@implementation MMLocationManager

+ (instancetype)sharedManager
{
    static MMLocationManager *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MMLocationManager alloc] init];
    });
    
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if ( self )
    {
        self.minSpeed = 0;
#warning 改filter
        self.minFilter = 0;
        self.minInteval = 100;
        
        self.delegate = self;
        self.distanceFilter  = kCLDistanceFilterNone;//self.minFilter;
        self.desiredAccuracy = kCLLocationAccuracyBest;
        
        [self initializeFile];
    }
    return self;
}



- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = locations[0];
    
    NSLog(@"%@",location);
    
    //[self adjustDistanceFilter:location];
    [self uploadLocation:location];
}

/**
 *  规则: 如果速度小于minSpeed m/s 则把触发范围设定为50m
 *  否则将触发范围设定为minSpeed*minInteval
 *  此时若速度变化超过10% 则更新当前的触发范围(这里限制是因为不能不停的设置distanceFilter,
 *  否则uploadLocation会不停被触发)
 */
- (void)adjustDistanceFilter:(CLLocation*)location
{
    if ( location.speed < self.minSpeed )
    {
        if (fabs(self.distanceFilter-self.minFilter) > 0.1f )
        {
            self.distanceFilter = self.minFilter;
        }
    }
    else
    {
        CGFloat lastSpeed = self.distanceFilter/self.minInteval;
        
        if ( (fabs(lastSpeed-location.speed)/lastSpeed > 0.1f) || (lastSpeed < 0) )
        {
            CGFloat newSpeed  = (int)(location.speed+0.5f);
            CGFloat newFilter = newSpeed*self.minInteval;
            
            self.distanceFilter = newFilter;
        }
    }
}


//这里仅用本地数据库模拟上传操作
- (void)uploadLocation:(CLLocation*)location{
    
    if ( [UIApplication sharedApplication].applicationState == UIApplicationStateActive )
    {
        //TODO HTTP upload
        NSLog(@"http upload mm");
        [self transferLocation:location];
        [self endBackgroundUpdateTask];
    }
    else//后台定位
    {
        //假如上一次的上传操作尚未结束 则直接return
        if ( self.taskIdentifier != UIBackgroundTaskInvalid ){
            return;
        }
        [self beginBackgroundUpdateTask];
        [self transferLocation:location];
        //上传完成记得调用 [self endBackgroundUpdateTask];
    }
    
}


- (void)beginBackgroundUpdateTask
{
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask
{
    if ( self.taskIdentifier != UIBackgroundTaskInvalid )
    {
        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}

- (void)transferLocation:(CLLocation*)location{
    
    [self logLocation:[@(location.coordinate.latitude) description] lng:[@(location.coordinate.longitude) description] success:false];
    
      [[XYAPIService shareInstance]transferCoordinate:location.coordinate.latitude and:location.coordinate.longitude success:^(NSArray *locationArray){
             if (!locationArray || [locationArray count]<2) {
                 [self uploadToServer:@[[NSString stringWithFormat:@"%.5f",location.coordinate.latitude],[NSString stringWithFormat:@"%.5f",location.coordinate.longitude]]];
             }else{
                 [self uploadToServer:@[[locationArray objectAtIndex:1],[locationArray objectAtIndex:0]]];
             }
         }errorString:^(NSString *error){
             [self uploadToServer:@[[NSString stringWithFormat:@"%.5f",location.coordinate.latitude],[NSString stringWithFormat:@"%.5f",location.coordinate.longitude]]];
         }];
}

- (void)uploadToServer:(NSArray*)array {//(NSString*)lat lng:(NSString*)lng{
    NSString* lat = array[0];
    NSString* lng = array[1];
    [[XYAPIService shareInstance]postCoordinate:lat and:lng success:^(NSInteger nextUpdate) {
        [self logLocation:lat lng:lng success:true];
    } errorString:^(NSString *e) {
        [self appendString:[NSString stringWithFormat:@"失败了 %@\n",e]];
        [self performSelector:@selector(uploadToServer:) withObject:array afterDelay:10];
    }];
}


- (void)initializeFile{
    self.fileManager = [NSFileManager defaultManager];
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    self.filePath = [documentDirectory stringByAppendingPathComponent:@"locationMM.txt"];
    if (![self.fileManager fileExistsAtPath:self.filePath]) {
        [self.fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
        [self appendString:@"创建文件成功！\n"];
    }
    
}


- (void)logLocation:(NSString*)lat lng:(NSString*)lng success:(BOOL)uploaded{
    [self appendString:[NSString stringWithFormat:@"%@ : %@,%@  upload:%@ \n",[NSDate date],lat,lng,uploaded?@"success":@"ready"]];
    if (uploaded) {
        [self endBackgroundUpdateTask];
    }
}

- (void)appendString:(NSString *)s{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location.txt"];
    NSFileHandle* outFile = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
    if(!outFile){
        return;
    }
    [outFile seekToEndOfFile];
    NSData* buffer = [s dataUsingEncoding:NSUTF8StringEncoding];
    [outFile writeData:buffer];
    [outFile closeFile];
}


@end
