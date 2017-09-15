//
//  SocketClient.h
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Socket管理类 
 */
@interface XYSocketClient : NSObject

+ (XYSocketClient*)sharedInstance;

- (BOOL)connectServer;

@end
