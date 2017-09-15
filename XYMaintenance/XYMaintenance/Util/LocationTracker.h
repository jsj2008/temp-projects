//
//  LocationTracker.h
//  Location
//
//  Created by Rick
//  Copyright (c) 2014 Location. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LocationShareModel.h"

@interface LocationTracker : NSObject <CLLocationManagerDelegate>

@property (nonatomic        ) CLLocationCoordinate2D myLastLocation;
@property (nonatomic        ) CLLocationAccuracy     myLastLocationAccuracy;

@property (strong,nonatomic ) LocationShareModel     * shareModel;

@property (nonatomic        ) CLLocationCoordinate2D myLocation;
@property (nonatomic        ) CLLocationAccuracy     myLocationAccuracy;

@property (assign,nonatomic ) BOOL                   isBackground;


@property (strong, nonatomic) NSFileManager          * fileManager;
@property (strong, nonatomic) NSString               * filePath;



+ (CLLocationManager *)sharedLocationManager;

- (void)startLocationTracking;
- (void)stopLocationTracking;
- (void)updateLocationToServer;

@end