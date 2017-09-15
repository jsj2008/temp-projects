//
//  XYThreadSafeDictionary.m
//  XYMaintenance
//
//  Created by Kingnet on 16/8/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import "XYThreadSafeDictionary.h"
#import "XYConfig.h"
#import "MJExtension.h"

@interface XYThreadSafeDictionary () {
    dispatch_queue_t concurrentQueue;
}
@property(strong,nonatomic)NSMutableDictionary* dic;
@end

@implementation XYThreadSafeDictionary

- (id)init{
    if (self = [super init]) {
        concurrentQueue = dispatch_queue_create("XYThreadSafeDictionary", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSMutableDictionary*)dic{
    if (!_dic) {
        _dic = [[NSMutableDictionary alloc]init];
    }
    return _dic;
}

- (void)initDicContent:(NSDictionary*)dic{
    self.dic = [[NSMutableDictionary alloc]initWithDictionary:dic];
}

- (NSInteger)numberOfItemsInDic{
    return [self.dic count];
}

- (NSArray*)cachedKeys{
    return [self.dic allKeys];
}

- (void)objectForKey:(id)aKey block:(XYThreadSafeDictionaryBlock)block{
    TTDEBUGLOG(@"_unUploadedAlbumImagesMap = %@",self.dic);
    id key = [aKey copy];
    __weak __typeof__(self) weakSelf = self;
    dispatch_async(concurrentQueue, ^{
        XYThreadSafeDictionary *strongSelf = weakSelf;
        if (!strongSelf)return;
        id object = [self.dic objectForKey:key];
        block(self.dic, key, object);
    });
}

- (void)setObject:(id)object forKey:(NSString*)key block:(XYThreadSafeDictionaryBlock)block{
    TTDEBUGLOG(@"_unUploadedAlbumImagesMap = %@",self.dic);
    if (!key) {
        return;
    }
    NSString* akey = [key copy];
    __weak XYThreadSafeDictionary *weakSelf = self;
        dispatch_barrier_async(concurrentQueue, ^{
            XYThreadSafeDictionary *strongSelf = weakSelf;
            if (!strongSelf)
                return;
            if (!object) {
                [self.dic removeObjectForKey:akey];
            }else{
                [self.dic setObject:object forKey:akey];
            }
            if (block) {
                block(strongSelf.dic, akey, object);
            }
        });
}

- (NSString*)jsonStr{
    TTDEBUGLOG(@"jsonStr = %@",[self.dic mj_JSONString]);
    return [self.dic mj_JSONString];
}

@end
