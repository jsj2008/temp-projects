//
//  XYLocationManagerBackground.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYLocationManagerBackground.h"
#import "XYAPIService+V1API.h"
#import "XYConfig.h"

@interface XYLocationManagerBackground()<CLLocationManagerDelegate>

@property (nonatomic, assign) UIBackgroundTaskIdentifier taskIdentifier;

@property (strong, nonatomic) NSFileManager* fileManager;
@property (strong, nonatomic) NSString* filePath;

@end


@implementation XYLocationManagerBackground

+ (instancetype)sharedManager{
    
    static XYLocationManagerBackground *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYLocationManagerBackground alloc] init];
    });
    return instance;
}

- (instancetype)init{

    if ( self = [super init]){
        self.delegate = self;
        self.distanceFilter  = kCLDistanceFilterNone;
        self.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        [self registerNotification];
        [self startMonitoringSignificantLocationChanges];
        
      //  [self initializeFile];
    }
    return self;
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startMonitoringLocation) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)startMonitoringLocation{
    [self startMonitoringSignificantLocationChanges];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    if ([locations count]==0) {
        return;
    }
    CLLocation *location = locations[0];
    [self uploadLocation:location];
}

- (void)uploadLocation:(CLLocation*)location{
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive ){
       // [self appendString:@"UIApplicationStateActive\n"];
        [self transferLocation:location];
        [self endBackgroundUpdateTask];
    }else{//后台定位
      //  [self appendString:@"UIApplicationStateActive NOT\n"];
        //假如上一次的上传操作尚未结束 则直接return
        if ( self.taskIdentifier != UIBackgroundTaskInvalid ){
            return;
        }
        [self beginBackgroundUpdateTask];
        [self transferLocation:location];
        //上传完成记得调用 [self endBackgroundUpdateTask];
    }
}

- (void)beginBackgroundUpdateTask{
    self.taskIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [self endBackgroundUpdateTask];
    }];
}

- (void)endBackgroundUpdateTask{
    if ( self.taskIdentifier != UIBackgroundTaskInvalid ){
        [[UIApplication sharedApplication] endBackgroundTask: self.taskIdentifier];
        self.taskIdentifier = UIBackgroundTaskInvalid;
    }
}


- (void)transferLocation:(CLLocation*)location{
    
//    [self logLocation:[@(location.coordinate.latitude) description] lng:[@(location.coordinate.longitude) description] success:false];
    
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
    //开关
    [[XYAPIService shareInstance]postCoordinate:lat and:lng success:^(NSInteger nextUpdate) {
       // [self logLocation:lat lng:lng success:true];
            [self endBackgroundUpdateTask];
    } errorString:^(NSString *e) {
       // [self appendString:[NSString stringWithFormat:@"失败了 %@\n",e]];
        //[self performSelector:@selector(uploadToServer:) withObject:array afterDelay:100];
    }];
}


//- (void)initializeFile{
//    self.fileManager = [NSFileManager defaultManager];
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
//    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_background.txt"];
//    if (![self.fileManager fileExistsAtPath:self.filePath]) {
//        [self.fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
//      //  [self appendString:@"创建文件成功！\n"];
//    }
//    
//}

//- (void)logLocation:(NSString*)lat lng:(NSString*)lng success:(BOOL)uploaded{
//   // [self appendString:[NSString stringWithFormat:@"%@ : %@,%@  upload:%@ \n",[NSDate date],lat,lng,uploaded?@"success":@"ready"]];
//    if (uploaded) {
//        [self endBackgroundUpdateTask];
//    }
//}

//- (void)appendString:(NSString *)s{
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
//    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_background.txt"];
//    NSFileHandle* outFile = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
//    if(!outFile){
//        return;
//    }
//    [outFile seekToEndOfFile];
//    NSData* buffer = [s dataUsingEncoding:NSUTF8StringEncoding];
//    [outFile writeData:buffer];
//    [outFile closeFile];
//}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status){
        case kCLAuthorizationStatusAuthorizedAlways:
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusNotDetermined:
            if(IS_IOS_8_LATER){
                [manager requestAlwaysAuthorization];
                if (IS_IOS_9_LATER){
                    manager.allowsBackgroundLocationUpdates = YES;
                }
            }
        default:
            break;
    }
}


@end
