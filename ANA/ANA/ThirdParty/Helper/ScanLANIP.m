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
    ConnectTCP *_connectTCP;
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
        _connectTCP = [ConnectTCP shareInstance];
        _connectTCP.delegate = self;
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
    
   GCDAsyncSocket* socket = [_connectTCP connectSocketWithHost:host port:port];
    if (!socket) {
        NSLog(@"Connect failed");
    }
}
-(void)connectTCPDidDisconnectHostWithError:(NSError *)error{
    NSLog(@"Connect failed");
}
-(void)connectTCPDidConnectHost:(NSString *)host{
    if (_scanLan) {
        [_scanLan stopScan];
    }
    
    if ([self.delegate respondsToSelector:@selector(scanLANIPDidConnectToANA:)]) {
        [self.delegate scanLANIPDidConnectToANA:_connectTCP];
    }
}
- (void)scanLANDidFindNewAdrress:(NSString *)address havingHostName:(NSString *)hostName {
    NSLog(@"found  %@", address);
    [self connectToHost:address andPort:HOST_TCP_ANA];
}

- (void)scanLANDidFinishScanning {
    if ([self.delegate respondsToSelector:@selector(scanLANIPDidFinishedScan:)]) {
        [self.delegate scanLANIPDidFinishedScan:_connectTCP];
    }
    NSLog(@"Scan LAN did finish");
}
@end
