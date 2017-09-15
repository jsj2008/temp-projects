//
//  XYLocationWithTimer.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/12/18.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYLocationManagerWithTimer.h"
#import "XYAPIService+V1API.h"
#import "XYConfig.h"
#import "XYAlertTool.h"
#import "XYAPPSingleton.h"
#import "HttpCache.h"

static CGFloat const locUpdateInterval = 1; //一分钟上报一次。。。。。。。。。。。。。。。

@implementation XYLocationManagerWithTimer

+ (instancetype)sharedManager{
    static XYLocationManagerWithTimer *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XYLocationManagerWithTimer alloc] init];
    });
    return instance;
}

- (id)init{
   
    if (self = [super init]) {
        [self registerNotification];
        [self restartTimer];
    }
    return self;
}

- (void)registerNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)applicationEnterBackground{
   // [self appendString:@"applicationEnterBackground\n"];
}

- (void)applicationEnterForeground{
    [self restartTimer];
    [self updateLocation];
}

- (void)restartTimer{
    
    if (self.uploadTimer) {
        [self.uploadTimer invalidate];
        self.uploadTimer = nil;
    }
    NSInteger timeInterval;
    CGFloat jp_locationInterval = [[[XYConfigParamUtil jp_config] objectForKey:@"jp_locationInterval"] floatValue];
    if (jp_locationInterval) {
        timeInterval = jp_locationInterval;
    }else {
        timeInterval = locUpdateInterval;
    }
    self.uploadTimer = [NSTimer scheduledTimerWithTimeInterval:60.0 * timeInterval
                                     target:self
                                   selector:@selector(updateLocation)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)updateLocation{
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(![CLLocationManager locationServicesEnabled] ||authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            //检测定位-开关
            if([XYConfigParamUtil xy_config].location==0){
                return;
            }
            //检测定位是否开启
            [UIAlertView showAlertWithTitle:@"定位服务不可用" message:@"您尚未开启定位功能，请设置开启后继续使用。" cancelButtonTitle:nil otherButtonTitles:@[@"前往设置"] tapBlock:^NSInteger(UIAlertView *alertView, NSInteger buttonIndex) {
                if (IS_IOS_8_LATER&(UIApplicationOpenSettingsURLString != NULL)) {
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                    if([[UIApplication sharedApplication] canOpenURL:url])
                    {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
   
                [alertView dismissWithClickedButtonIndex:buttonIndex animated:false];
                return buttonIndex;
            }];
        }else{
            //开始定位
           [self.locationManager requestLocationWithReGeocode:false completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
               if (error) {
                   [self updateLocation];
                   return;
               }
               if ([self isReasonableLocation:location.coordinate]) {
                   [self.locationManager stopUpdatingLocation];
                   self.myLastLocation = location.coordinate;
                   self.myLastAddress = regeocode.formattedAddress;
                   [self performSelector:@selector(uploadLocationToServer) withObject:nil];
               }
           }];
           return;
        }
}

- (void)uploadLocationToServer{
    if ([XYAPPSingleton sharedInstance].hasLogin) {
        [self uploadToServer:@[[NSString stringWithFormat:@"%.5f",self.myLastLocation.latitude],[NSString stringWithFormat:@"%.5f",self.myLastLocation.longitude]]];
    }
}


- (void)uploadToServer:(NSArray*)array {
    NSString* lat = array[0];
    NSString* lng = array[1];
    TTDEBUGLOG(@"上传到服务器：%@，%@",lat,lng);
    [[XYAPIService shareInstance]postCoordinate:lat and:lng success:^(NSInteger nextUpdate) {

    } errorString:^(NSString *e) {

    }];
}

#pragma mark - test

//- (void)initializeFile{
//    self.fileManager = [NSFileManager defaultManager];
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,      NSUserDomainMask, YES);
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
//    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_front.txt"];
//    if (![self.fileManager fileExistsAtPath:self.filePath]) {
//        [self.fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
//        [self appendString:@"创建文件成功！\n"];
//    }
//}


- (void)logLocation:(NSString*)lat lng:(NSString*)lng success:(BOOL)uploaded{
  //  [self appendString:[NSString stringWithFormat:@"%@ : %@,%@  upload:%@ \n",[NSDate date],lat,lng,uploaded?@"success":@"ready"]];
}

//- (void)appendString:(NSString *)s{
//    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
//    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
//    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_front.txt"];
//    NSFileHandle* outFile = [NSFileHandle fileHandleForWritingAtPath:self.filePath];
//    if(!outFile){
//        return;
//    }
//    [outFile seekToEndOfFile];
//    NSData* buffer = [s dataUsingEncoding:NSUTF8StringEncoding];
//    [outFile writeData:buffer];
//    [outFile closeFile];
//}

#pragma mark - tool

- (BOOL)isReasonableLocation:(CLLocationCoordinate2D)location{
    if (location.latitude>0 && location.longitude>0){
        return true;
    }
    return false;
}

#pragma mark - property

- (AMapLocationManager*)locationManager{

    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        if (IS_IOS_9_LATER) {
            _locationManager.allowsBackgroundLocationUpdates = YES;
        }
    }
    return _locationManager;
}

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
