//
//  XYAMapManager.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/11/14.
//  Copyright © 2015年 Kingnet. All rights reserved.
//

#import "XYAMapManager.h"
#import "XYConfig.h"
#import "MJExtension.h"

@implementation XYAMapManager

+(instancetype)sharedInstance{
    static XYAMapManager* sharedBGTaskManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedBGTaskManager = [[XYAMapManager alloc] init];
    });
    return sharedBGTaskManager;
}

- (MAMapView*)aMapView{
    if (!_aMapView) {
        _aMapView = [[MAMapView alloc]init];
        [_aMapView setZoomLevel:_aMapView.maxZoomLevel - 5];
        _aMapView.delegate = self;
        _aMapView.showsUserLocation = true;
        _aMapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;
        _aMapView.pausesLocationUpdatesAutomatically = false;
    }
    return _aMapView;
}

- (AMapSearchAPI*)aMapSearchAPI{
    if (!_aMapSearchAPI) {
        [MAMapServices sharedServices].apiKey = GAODE_KEY;
        _aMapSearchAPI = [[AMapSearchAPI alloc]init];
    }
    return _aMapSearchAPI;
}

- (void)clearMapView{
    
    for (id<MAAnnotation> anno in self.aMapView.annotations) {
        if (![anno isKindOfClass:[MAUserLocation class]]) {
            [self.aMapView removeAnnotation:anno];
        }
    }
    [self.aMapView removeOverlays:self.aMapView.overlays];
    self.aMapView.showsUserLocation = true;
}

- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation{
   // NSLog(@"amap userLocation = %f %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error{
    //NSLog(@"amap fail = %@",[error localizedDescription]);
}

//MAMetersBetweenMapPoints(MAMapPointForCoordinate(startCoor), MAMapPointForCoordinate(endCoor));
@end
