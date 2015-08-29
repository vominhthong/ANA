//
//  ScanLANIP.m
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "ScanLANIP.h"
#import "ScanLAN.h"
#import "ConnectTCP.h"
#import "Constants.h"
@interface ScanLANIP () <ScanLANDelegate,ConnectTCPDelegate>{
    ScanLAN *_scanLan;
    dispatch_queue_t connectQueue;
    void* connectQueueTag;
}
@end

@implementation ScanLANIP
+(ScanLANIP *)shareInstance{
    static ScanLANIP *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ScanLANIP alloc]init];
    });
    return _instance;
}
-(instancetype)init{
    if (self = [super init]) {
        _scanLan = [[ScanLAN alloc]initWithDelegate:self];
        self._connectTCP = [ConnectTCP shareInstance];
        self._connectTCP.delegate = self;
        
        connectQueue = dispatch_queue_create("Connect QUEUE", DISPATCH_QUEUE_SERIAL);
        connectQueueTag = &connectQueueTag;
        dispatch_queue_set_specific(connectQueue, connectQueueTag, connectQueueTag, NULL);
    }
    return self;
}
-(void)stopScanIPInLan{
    [_scanLan stopScan];
}
-(void)startScanIPInLan{
    [_scanLan startScan];
}
-(void)connectToHost:(NSString*)host andPort:(uint16_t)port{
    
    if ([host isEqualToString:@"192.168.1.49"]) {
        NSLog(@"OK");
    }
   GCDAsyncSocket* socket = [self._connectTCP connectSocketWithHost:host port:port];
    if (!socket) {
        NSLog(@"Connect failed");
    }
}
-(void)connectTCPDidDisconnectHostWithError:(NSError *)error{
   // self._connectTCP.isConnected = NO;
    if (self._connectTCP.roomBindingCode.length > 0) {
        [self._connectTCP connectSocketWithHost:self._connectTCP.hostIP port:HOST_TCP_ANA];
    }
    NSLog(@"connectTCPDidDisconnectHostWithError");
}
-(void)connectTCPDidConnectHost:(NSString *)host{
    if (_scanLan) {
        [_scanLan stopScan];
    }
    if ([self.delegate respondsToSelector:@selector(scanLANIPDidConnectToANA:)]) {
        [self.delegate scanLANIPDidConnectToANA:self._connectTCP];
    }
}
- (void)scanLANDidFindNewAdrress:(NSString *)address havingHostName:(NSString *)hostName {
    NSLog(@"found  %@", address);
    __weak typeof(self)wSelf = self;
    dispatch_block_t block = ^{
        [wSelf connectToHost:@"192.168.1.49" andPort:HOST_TCP_ANA];
    };
    if (dispatch_get_specific(connectQueueTag)) {
        block();
    }else{
        dispatch_async(connectQueue, block);
    }
}

- (void)scanLANDidFinishScanning {
    if ([self.delegate respondsToSelector:@selector(scanLANIPDidFinishedScan:)]) {
        [self.delegate scanLANIPDidFinishedScan:self._connectTCP];
    }
    NSLog(@"Scan LAN did finish");
}
@end
