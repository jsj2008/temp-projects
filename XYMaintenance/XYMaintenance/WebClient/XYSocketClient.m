//
//  SocketClient.m
//  XYMaintenance
//
//  Created by yangmr on 15/7/14.
//  Copyright (c) 2015年 Kingnet. All rights reserved.
//

#import "XYSocketClient.h"
#import "GCDAsyncSocket.h"

static NSString* const kSocketHost = @"";//服务器
static uint16_t const kSocketPort = 8080;//端口
static NSTimeInterval const kTimeOut = 10;//端口

typedef NS_ENUM(NSUInteger, XYSocketCutOffType)
{
    XYSocketOfflineByServer,// 服务器掉线，默认为0
    XYSocketOfflineByUser,  // 用户主动cut
};


@interface XYSocketClient ()<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket* _socket;
}
@end

@implementation XYSocketClient

+ (XYSocketClient*)sharedInstance
{
    static dispatch_once_t onceToken;
    static XYSocketClient *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[XYSocketClient alloc] init];
    });
    return sharedInstance;
}

- (BOOL)connectServer
{
    if (!_socket)
    {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    NSError *err = nil;
    if(![_socket connectToHost:kSocketHost onPort:kSocketPort withTimeout:kTimeOut error:&err])
    {
       NSLog(@"Error: %@", err);
       //[self connectServer];//重连
       return false;
    }
    else
    {
        return true;
    }
}

- (void)receiveData
{
    [_socket readDataWithTimeout:-1 tag:0];
}

- (void)writeData:(NSData*)data
{
   [_socket writeData:data withTimeout:-1 tag:0];
}

- (void)disconnect
{
    _socket.userData = @(XYSocketOfflineByUser);
    [_socket disconnect];
}


#pragma mark - socket delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"socket连接成功");
    //心跳包
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{

}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{

}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (![sock.userData isEqual:@(XYSocketOfflineByUser)])
    {
        [self connectServer];//掉线重连
        return;
    }
}

@end
