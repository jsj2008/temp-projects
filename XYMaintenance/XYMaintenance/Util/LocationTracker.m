//
//  LocationTracker.m
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location All rights reserved.
//

#import "LocationTracker.h"
#import "XYAPIService.h"
#import "XYConfig.h"
#import "CacheHelper.h"
#import "XYAMapManager.h"

#define LATITUDE @"latitude"
#define LONGITUDE @"longitude"
#define ACCURACY @"theAccuracy"

@implementation LocationTracker

+ (CLLocationManager *)sharedLocationManager {
    
	static CLLocationManager *_locationManager;
	
	@synchronized(self) {
		if (_locationManager == nil) {
			_locationManager = [[CLLocationManager alloc] init];
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.distanceFilter = kCLDistanceFilterNone;
            if (IS_IOS_8_LATER) {
                [_locationManager requestAlwaysAuthorization];
            }
            if (IS_IOS_9_LATER) {
                _locationManager.allowsBackgroundLocationUpdates = YES;
            }
		}
	}
	return _locationManager;
}

- (id)init {
	if (self==[super init]){
        //Get the share model and also initialize myLocationArray
        self.shareModel = [LocationShareModel sharedModel];
        self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
        self.isBackground=false;
        [self initializeFile];
	}
	return self;
}

- (void)applicationEnterBackground{
    [self onAppStartusChanged:true];
}

- (void)applicationEnterForeground{
    [self onAppStartusChanged:false];
}

- (void)onAppStartusChanged:(BOOL)isBackground{
    self.isBackground = isBackground;
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    locationManager.delegate = self;
    if (isBackground) {
       [locationManager startMonitoringSignificantLocationChanges];
    }else{
       [locationManager startUpdatingLocation];
    }
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        //Use the BackgroundTaskManager to manage all the background Task
        self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
        [self.shareModel.bgTask beginNewBackgroundTask];
    }
}

- (void)restartLocationUpdates{
    TTDEBUGLOG(@"restartLocationUpdates");
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
        self.shareModel.timer = nil;
    }
    [self onAppStartusChanged:self.isBackground];
}


- (void)startLocationTracking {
    TTDEBUGLOG(@"startLocationTracking");
	if (![CLLocationManager locationServicesEnabled]){
		UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"该设备当前位置服务不可用" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
		[servicesDisabledAlert show];
	}else{
        CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
        if(authorizationStatus == kCLAuthorizationStatusDenied || authorizationStatus == kCLAuthorizationStatusRestricted){
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用" message:@"请前往“设置->通用”打开Hi维修定位服务，便于后台获取您的位置，分派相应区域的订单。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        }else{
            [self onAppStartusChanged:self.isBackground];
        }
	}
}


- (void)stopLocationTracking{
    TTDEBUGLOG(@"stopLocationTracking");
    if (self.shareModel.timer) {
        [self.shareModel.timer invalidate];
         self.shareModel.timer = nil;
    }
	CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        [locationManager stopMonitoringSignificantLocationChanges];
    }else{
        [locationManager stopUpdatingLocation];
    }
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    TTDEBUGLOG(@"locationManager didUpdateLocations");
    
    for(int i=0;i<locations.count;i++){
        
        CLLocation * newLocation = [locations objectAtIndex:i];
        CLLocationCoordinate2D theLocation = newLocation.coordinate;
        CLLocationAccuracy theAccuracy = newLocation.horizontalAccuracy;
        NSTimeInterval locationAge = -[newLocation.timestamp timeIntervalSinceNow];
        if (locationAge > 30.0){
            continue;
        }
        //Select only valid location and also location with good accuracy
        if(newLocation!=nil&&theAccuracy>0
           &&theAccuracy<2000
           &&(!(theLocation.latitude==0.0&&theLocation.longitude==0.0))){
            self.myLastLocation = theLocation;
            self.myLastLocationAccuracy= theAccuracy;
            NSMutableDictionary * dict = [[NSMutableDictionary alloc]init];
            [dict setObject:[NSNumber numberWithFloat:theLocation.latitude] forKey:@"latitude"];
            [dict setObject:[NSNumber numberWithFloat:theLocation.longitude] forKey:@"longitude"];
            [dict setObject:[NSNumber numberWithFloat:theAccuracy] forKey:@"theAccuracy"];
            //Add the vallid location with good accuracy into an array
            //Every 1 minute, I will select the best location based on accuracy and send to server
            [self.shareModel.myLocationArray addObject:dict];
        }
    }
    
    //If the timer still valid, return it (Will not run the code below)
    if (self.shareModel.timer) {
        return;
    }
    
    self.shareModel.bgTask = [BackgroundTaskManager sharedBackgroundTaskManager];
    [self.shareModel.bgTask beginNewBackgroundTask];
    
    //Restart the locationMaanger after 1 minute
    self.shareModel.timer = [NSTimer scheduledTimerWithTimeInterval:60 * XY_DO_LOCATION_INTERVAL target:self
                                                           selector:@selector(restartLocationUpdates)
                                                           userInfo:nil
                                                            repeats:NO];
    
    //Will only stop the locationManager after 10 seconds, so that we can get some accurate locations
    //The location manager will only operate for 10 seconds to save battery
    if (self.shareModel.delay10Seconds) {
        [self.shareModel.delay10Seconds invalidate];
        self.shareModel.delay10Seconds = nil;
    }
    
    self.shareModel.delay10Seconds = [NSTimer scheduledTimerWithTimeInterval:5 target:self
                                                    selector:@selector(stopLocationDelayBy10Seconds)
                                                    userInfo:nil
                                                     repeats:NO];
    
}


//Stop the locationManager
-(void)stopLocationDelayBy10Seconds{
    
    CLLocationManager *locationManager = [LocationTracker sharedLocationManager];
    if (self.isBackground) {
        [locationManager stopMonitoringSignificantLocationChanges];

            [self updateLocationToServer];
        
    }else{
        [locationManager stopUpdatingLocation];
    }
    TTDEBUGLOG(@"locationManager stop Updating after 10 seconds");
}

- (void)locationManager: (CLLocationManager *)manager didFailWithError: (NSError *)error{
    
    TTDEBUGLOG(@"locationManager error:%@",error);
    
    switch([error code]){
        case kCLErrorNetwork:{
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"网络不稳定" message:@"请检查网络连接。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        }
            break;
        case kCLErrorDenied:{
            UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"定位服务不可用" message:@"请前往“设置->通用”打开Hi维修定位服务，便于后台获取您的位置，分派相应区域的订单。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [servicesDisabledAlert show];
        }
            break;
        default:{}
            break;
    }
}


//Send the location to Server
- (void)updateLocationToServer{
    
    TTDEBUGLOG(@"updateLocationToServer");
    
    // Find the best location from the array based on accuracy
    NSMutableDictionary * myBestLocation = [[NSMutableDictionary alloc]init];
    
    for(int i=0;i<self.shareModel.myLocationArray.count;i++){
        NSMutableDictionary * currentLocation = [self.shareModel.myLocationArray objectAtIndex:i];
        if(i==0)
            myBestLocation = currentLocation;
        else{
            if([[currentLocation objectForKey:ACCURACY]floatValue]<=[[myBestLocation objectForKey:ACCURACY]floatValue]){
                myBestLocation = currentLocation;
            }
        }
    }
    //If the array is 0, get the last location
    //Sometimes due to network issue or unknown reason, you could not get the location during that  period, the best you can do is sending the last known location to the server
    if(self.shareModel.myLocationArray.count==0){
        TTDEBUGLOG(@"Unable to get location, use the last known location");
        self.myLocation=self.myLastLocation;
        self.myLocationAccuracy=self.myLastLocationAccuracy;
    }else{
        CLLocationCoordinate2D theBestLocation;
        theBestLocation.latitude =[[myBestLocation objectForKey:LATITUDE]floatValue];
        theBestLocation.longitude =[[myBestLocation objectForKey:LONGITUDE]floatValue];
        self.myLocation=theBestLocation;
        self.myLocationAccuracy =[[myBestLocation objectForKey:ACCURACY]floatValue];
    }
    
    NSLog(@"Send to Server: Latitude(%f) Longitude(%f) Accuracy(%f)",self.myLocation.latitude, self.myLocation.longitude,self.myLocationAccuracy);
    
    [self transferLocation:self.myLocation];
    
    // slashss
    
    [self.shareModel.myLocationArray removeAllObjects];
    self.shareModel.myLocationArray = nil;
    self.shareModel.myLocationArray = [[NSMutableArray alloc]init];
}

- (void)transferLocation:(CLLocationCoordinate2D)location{

    [self logLocation:[@(location.latitude) description] lng:[@(location.longitude) description] success:false];

    [[XYAPIService shareInstance]transferCoordinate:location.latitude and:location.longitude success:^(NSArray *locationArray){
        if (!locationArray || [locationArray count]<2) {
            [self uploadToServer:@[[NSString stringWithFormat:@"%.5f",location.latitude],[NSString stringWithFormat:@"%.5f",location.longitude]]];
        }else{
            [self uploadToServer:@[[locationArray objectAtIndex:1],[locationArray objectAtIndex:0]]];
        }
    }errorString:^(NSString *error){
        [self uploadToServer:@[[NSString stringWithFormat:@"%.5f",location.latitude],[NSString stringWithFormat:@"%.5f",location.longitude]]];
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
    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_old.txt"];
    if (![self.fileManager fileExistsAtPath:self.filePath]) {
        [self.fileManager createFileAtPath:self.filePath contents:nil attributes:nil];
        [self appendString:@"创建文件成功！\n"];
    }
}


- (void)logLocation:(NSString*)lat lng:(NSString*)lng success:(BOOL)uploaded{
    [self appendString:[NSString stringWithFormat:@"%@ : %@,%@  upload:%@ \n",[NSDate date],lat,lng,uploaded?@"success":@"ready"]];
}

- (void)appendString:(NSString *)s{
    NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [directoryPaths objectAtIndex:0];
    self.filePath = [documentDirectory stringByAppendingPathComponent:@"location_old.txt"];
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
