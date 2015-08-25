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

-(GCDAsyncSocket*)connectSocketWithHost:(NSString*)host port:(uint16_t)port;

@property (nonatomic) id <ConnectTCPDelegate> delegate;
@end
