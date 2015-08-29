
//  ConnectTCP.m
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "ConnectTCP.h"
#import "XMLPackets.h"
#import "NSXMLElement+XMPP.h"
#import "NSMutableData+HashPacketANA.h"
#import <UIKit/UIKit.h>
#import "UIView+Toast.h"
#import "Constants.h"
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
        self.isConnected = YES;
    }
    return self;
}

-(GCDAsyncSocket *)connectSocketWithHost:(NSString *)host port:(uint16_t)port{
    NSError *error = nil;
    [_socket connectToHost:host onPort:port error:&error];
    if (error) {
        [_socket disconnect];
        return nil;
    }else{
        return _socket;
    }
}
-(void)writeData:(NSString *)xmlString{
    if (!self.roomBindingCode || !self.isConnected) {
        [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Can't connect to BOX" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil] show];
        return;
    }
    [_socket readDataWithTimeout:10 tag:100];
    NSMutableData *data = [[[NSData alloc]initWithData:[xmlString dataUsingEncoding:NSUTF8StringEncoding]] mutableCopy];
    [_socket writeData:[data hasPacketAna] withTimeout:200 tag:101];
}
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port{
    
    if ([self.delegate respondsToSelector:@selector(connectTCPDidConnectHost:)]) {
        [self.delegate connectTCPDidConnectHost:host];
    }
    self.hostIP = host;
    
    /* handle read data from server tcp */
    [_socket readDataWithTimeout:10 tag:100];
    
    /* sent message to get binding code */
    XMLPackets *xmlPackets = [[XMLPackets alloc]init];
    NSString *getBindingCode = [[xmlPackets getBindingCodeToIPAna:host] compactXMLString];
    NSMutableData *data = [[[NSData alloc]initWithData:[getBindingCode dataUsingEncoding:NSUTF8StringEncoding]] mutableCopy];
    [sock writeData:[data hasPacketAna] withTimeout:1 tag:101];
    
}
-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
}

-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err{
    [sock disconnect];

    if ([self.delegate respondsToSelector:@selector(connectTCPDidDisconnectHostWithError:)]) {
        [self.delegate connectTCPDidDisconnectHostWithError:err];
    }
}
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    CFDataDeleteBytes((CFMutableDataRef)data, CFRangeMake(0, 8));
    NSError *errorWhenReadXML = nil;
    DDXMLDocument *dataFromServer = [[DDXMLDocument alloc]initWithData:data options:0 error:&errorWhenReadXML];
    NSXMLElement *element = [dataFromServer.children lastObject];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    if ([[[[element elementForName:@"body"] attributeForName:@"errorcode"] stringValue] intValue] == 0) {
        if ([[[element elementForName:@"body"] attributeForName:@"roombindingcode"] stringValue]) {
            [window makeToast:@"Kết nối thành công!"];
        }else{
            [window makeToast:@"Thao tác thành công!"];
        }
    }else{
        [window makeToast:@"Thao tác thất bại!"];
    }

    if (!element) {
        return;
    }
    /* actual */
    if (!self.roomBindingCode) {
        self.roomBindingCode = [[[element elementForName:@"body"] attributeForName:@"roombindingcode"] stringValue];
    }
    /* check record */
    
}
@end
