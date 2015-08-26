//
//  ConnectTCP.h
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol ConnectTCPDelegate <NSObject>

-(void)connectTCPDidConnectHost:(NSString*)host;

-(void)connectTCPDidDisconnectHostWithError:(NSError *)error;

@end

@interface ConnectTCP : NSObject
+(ConnectTCP*)shareInstance;
@property (nonatomic,strong) NSString *roomBindingCode;
@property (nonatomic,strong) NSString *hostIP;

-(GCDAsyncSocket*)connectSocketWithHost:(NSString*)host port:(uint16_t)port;

-(void)writeData:(NSString*)data;

@property (nonatomic) id <ConnectTCPDelegate> delegate;
@end
