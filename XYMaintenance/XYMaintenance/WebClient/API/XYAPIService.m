//
//  XYAPIService.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYAPIService.h"
#import "XYDtoContainer.h"
#import "XYCacheHelper.h"
#import "XYStringUtil.h"
#import "XYAPPSingleton.h"
#import "XYConfig.h"

@interface XYAPIService (){
    dispatch_queue_t _cacheQueue;
}
@property(strong,nonatomic)NSCache* cache;
@end

@implementation XYAPIService

+ (XYAPIService*)shareInstance{
    static dispatch_once_t onceToken;
    static XYAPIService *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYAPIService alloc] init];
    });
    return sharedInstance;
}

- (void)cancelRequestWithId:(NSNumber*)requestId{
    [[XYHttpClient sharedInstance] cancelRequestWithRequestID:requestId];
}

#pragma mark - api 

- (NSInteger)doLoginWithAccount:(NSString*)account password:(NSString*)password code:(NSString*)code success:(void (^)(XYUserDto* user))success errorString:(void (^)(NSString *))error{
    NSMutableDictionary* parameters = [[NSMutableDictionary alloc]init];
    [parameters setValue:account forKey:@"name"];
    [parameters setValue:password forKey:@"password"];
    [parameters setValue:code forKey:@"code"];
    NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:DO_LOGIN parameters:parameters isPost:true success:^(id response){
        XYDtoContainer* dto = [XYDtoContainer mj_objectWithKeyValues:response];
        if (dto.code == RESPONSE_SUCCESS){
            XYUserDto* user = [XYUserDto mj_objectWithKeyValues:dto.data];
            success(user);
        }else{
            error(dto.mes);
        }
    }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

- (NSInteger)doLogout:(void (^)())success errorString:(void (^)(NSString *))error{
   NSInteger requestId = [[XYHttpClient sharedInstance]requestPath:LOG_OUT parameters:nil isPost:false success:^(id response){
        success?success():nil;
     }failure:^(NSString *errorString){
        error?error(errorString):nil;
    }];
    return requestId;
}

#pragma mark - tool 

- (NSCache*)cache{
    if (!_cache) {
         _cache = [[NSCache alloc]init];
    }
    return _cache;
}

- (void)cacheResult:(id)result forPath:(NSString*)path{
    [self.cache setObject:result forKey:path];
}

- (id)getObjectForPath:(NSString*)path{
    return [self.cache objectForKey:path];
}


- (NSString *)dictionaryToJson:(NSArray *)dic{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
