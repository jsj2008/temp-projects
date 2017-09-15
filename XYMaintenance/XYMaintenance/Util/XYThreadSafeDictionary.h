//
//  XYThreadSafeDictionary.h
//  XYMaintenance
//
//  Created by Kingnet on 16/8/2.
//  Copyright © 2016年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XYThreadSafeDictionary;

typedef void (^XYThreadSafeDictionaryBlock)(NSDictionary *dict, NSString *key, id object);

@interface XYThreadSafeDictionary : NSObject
- (NSInteger)numberOfItemsInDic;
- (void)objectForKey:(id)aKey block:(XYThreadSafeDictionaryBlock)block;
- (void)setObject:(id)object forKey:(NSString*)key block:(XYThreadSafeDictionaryBlock)block;
- (void)initDicContent:(NSDictionary*)dic;
- (NSArray*)cachedKeys;
- (NSString*)jsonStr;
@end
