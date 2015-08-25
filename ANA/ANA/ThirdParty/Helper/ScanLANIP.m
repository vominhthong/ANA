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
-(void)startScanIPInLan{
    [_scanLan startScan];
}
-(void)connectToHost:(NSString*)host andPort:(uint16_t)port{
    [_connectTCP connectSocketWithHost:host port:port];
}
-(void)connectTCPDidDisconnectHostWithError:(NSError *)error{
    
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
    NSLog(@"Scan LAN did finish");
}
@end
