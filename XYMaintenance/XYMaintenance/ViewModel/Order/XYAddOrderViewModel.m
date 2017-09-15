//
//  XYAddOrderViewModel.m
//  XYMaintenance
//
//  Created by DamocsYang on 15/8/3.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYAddOrderViewModel.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

@interface XYAddOrderViewModel ()<AMapSearchDelegate>
@property(strong,nonatomic) AMapSearchAPI* searchAPI;
@property(strong,nonatomic) NSArray* titleArray;
@end

@implementation XYAddOrderViewModel

- (NSArray*)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"设备机型",@"设备故障",@"设备颜色",@"客户姓名",@"联系电话",@"地址",@""];
    }
    return _titleArray;
}

- (XYAddOrderCellType)getCellTypeByPath:(NSIndexPath*)path{
    NSInteger tag = (path.section*10+path.row);
    return (XYAddOrderCellType)tag;
}

- (NSString*)getTitleByPath:(NSIndexPath*)path{
    NSString* title = @"";
    @try {
        title = [self.titleArray objectAtIndex:path.row];
    }
    @catch (NSException *exception) {
        TTDEBUGLOG(@"exception:%@",exception);
        title = @"";
    }
    @finally {
        return title;
    }
}
- (NSString*)getPlaceHolderByType:(XYAddOrderCellType)type{
    switch (type) {
        case XYAddOrderCellTypeAddress:
            return @"详细地址（如门牌号等必填）";
            break;
        default:
            break;
    }
    return @"";
}

- (BOOL)getInputableByType:(XYAddOrderCellType)type{
    switch (type) {
        case XYAddOrderCellTypeName:
        case XYAddOrderCellTypePhone:
        case XYAddOrderCellTypeAddress:
            return true;
            break;
        default:
            break;
    }
    return false;
}

- (BOOL)getSelectableByType:(XYAddOrderCellType)type{
    switch (type) {
        case XYAddOrderCellTypeDevice:
        case XYAddOrderCellTypeFault:
            return true;
            break;
        default:
            break;
    }
    return false;
}
- (UIKeyboardType)getKeyboardByType:(XYAddOrderCellType)type{
    switch (type) {
        case XYAddOrderCellTypePhone:
            return UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    return UIKeyboardTypeDefault;
}

- (NSString*)getInputContentByPath:(NSIndexPath*)path{
    XYAddOrderCellType type = [self getCellTypeByPath:path];
    switch (type) {
        case XYAddOrderCellTypeDevice:
            return self.device.MouldName;
        case XYAddOrderCellTypeFault:
            return self.planDescription;
        case XYAddOrderCellTypeColor:
            return self.colorName;
        case XYAddOrderCellTypeName:
            return self.name;
        case XYAddOrderCellTypePhone:
            return self.phone;
        case XYAddOrderCellTypeVerifyCode:
            return self.code;
        default:
            break;
    }
    return @"";
}

- (AMapSearchAPI*)searchAPI{
    if (!_searchAPI) {
        [AMapServices sharedServices].apiKey = GAODE_KEY;
        _searchAPI = [[AMapSearchAPI alloc]init];
    }
    return _searchAPI;
}

- (void)doSubmitOrderWithPhone:(NSString*)phone andName:(NSString*)name address:(NSString*)address{
    
    if((!phone)||phone.length!=11){
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:false noteString:@"手机号长度不是11位，请检查输入！"];
        }
        return;
    }
    
    self.phone = phone;
    self.name = name;
    self.address = address;
    [self revertAddress:address];
}

- (void)getVerifyCode:(NSString*)account{
    [[XYAPIService shareInstance]sendVerifyCodeToUserPhone:self.phone success:^{
        if ([self.delegate respondsToSelector:@selector(onVerifyCodeSent:note:)]) {
            [self.delegate onVerifyCodeSent:true note:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onVerifyCodeSent:note:)]) {
            [self.delegate onVerifyCodeSent:false note:error];
        }
    }];
}

/**
 *  获取地址坐标
 */
- (void)revertAddress:(NSString*)address{
    self.searchAPI.delegate = self;
    AMapGeocodeSearchRequest *geo = [[AMapGeocodeSearchRequest alloc] init];
    geo.address = [NSString stringWithFormat:@"%@%@",self.areaName,address];
    geo.city = self.cityName;
    [self.searchAPI AMapGeocodeSearch:geo];
}

- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response{
    CLLocationCoordinate2D location;
    if ([response.geocodes count]>0) {
        AMapGeocode* code = response.geocodes[0];
        location = CLLocationCoordinate2DMake(code.location.latitude, code.location.longitude);
    }else{
        location = CLLocationCoordinate2DMake(0, 0);
    }
    [self uploadOrderInfoWithLocation:location];
}

- (void)uploadOrderInfoWithLocation:(CLLocationCoordinate2D)location{
    [[XYAPIService shareInstance]addOrderWithPlan:self.plan device:self.device.Id colorId:self.color phone:self.phone user:self.name city:self.cityId district:self.areaId address:self.address lat:location.latitude lng:location.longitude code:self.code  success:^{
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:true noteString:nil];
        }
    } errorString:^(NSString *error) {
        if ([self.delegate respondsToSelector:@selector(onOrderSubmitted:noteString:)]) {
            [self.delegate onOrderSubmitted:false noteString:error];
        }
    }];
}

- (void)dealloc{
    self.searchAPI.delegate = nil;
}



@end
