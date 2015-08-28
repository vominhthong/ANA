//
//  ConnectionNetwork.h
//  Zuus
//
//  Created by Vo Minh Thong on 5/11/15.
//  Copyright (c) 2015 Evizi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AFNetworkReachabilityManager.h"
#define kHandleConnectionNetwork      @"handleConnectionWithNotifi"

typedef enum : NSInteger {
    ConnectionNetworkStatusNotReachable = 0,
    ConnectionNetworkStatusReachableViaWiFi,
    ConnectionNetworkStatusReachableViaWWAN
} ConnectionNetworkStatus;

@interface ConnectionNetwork : NSObject

/* remove Reachability */
@property (strong, nonatomic) Reachability *reachability;
@property (nonatomic,strong) Reachability *googleReachability;
@property (nonatomic,strong) Reachability *wanReachability;

@property (nonatomic,assign) ConnectionNetworkStatus networkStatus;

/* Retry using AFNetworking for obsver network */
@property (nonatomic,strong) AFNetworkReachabilityManager *managerNetwork;
+(ConnectionNetwork*)shareInstance;


@end
