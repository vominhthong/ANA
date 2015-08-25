//
//  ConnectTCP.m
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "ConnectTCP.h"
@interface ConnectTCP ()<GCDAsyncSocketDelegate>{
    GCDAsyncSocket *_socket;

}
@end
@implementation ConnectTCP
+(ConnectTCP *)shareInstance{
    static ConnectTCP *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ConnectTCP alloc]init];
    });
    return _instance;
}

-(instancetype)init{
    if (self = [super init]) {
        _socket = [[GCDAsyncSocket alloc]initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

-(GCDAsyncSocket *)connectSocketWithHost:(NSString *)host port:(uint16_t)port{
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    if (error) {
        return nil;
    }else{
        return _socket;
    }
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    if ([self.delegate respondsToSelector:@selector(connectTCPDidConnectHost:)]) {
        [self.delegate connectTCPDidConnectHost:host];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    if ([self.delegate respondsToSelector:@selector(connectTCPDidDisconnectHostWithError:)]) {
        [self.delegate connectTCPDidDisconnectHostWithError:err];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
}
@end
