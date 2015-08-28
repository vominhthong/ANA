//
//  ConnectionNetwork.m
//  Zuus
//
//  Created by Vo Minh Thong on 5/11/15.
//  Copyright (c) 2015 Evizi. All rights reserved.
//

#import "ConnectionNetwork.h"
#import "AFNetworkReachabilityManager.h"
#import "Constants.h"

@implementation ConnectionNetwork
#pragma mark - Init life vehicle
+(ConnectionNetwork *)shareInstance{
    static ConnectionNetwork *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ConnectionNetwork alloc]init];
    });
    return _instance;
}

#pragma mark Memory Management
- (void)dealloc {
    // Stop Notifier
    if (self.reachability) {
        [self.reachability stopNotifier];
    }
}
#pragma mark - Private Method
-(void)handleConnectionWithNotifi:(NSNotification*)notifi{
    [self handleConnection];
    NotifPost2Obj(kHandleConnectionNetwork, @(self.managerNetwork.networkReachabilityStatus));
}
-(void)handleConnection{
    
    switch (self.managerNetwork.networkReachabilityStatus) {
        case NotReachable:
        {
            self.networkStatus = ConnectionNetworkStatusNotReachable;
        }
            break;
        case ReachableViaWiFi:{
            self.networkStatus = ConnectionNetworkStatusReachableViaWiFi;
        }
            break;
        case ReachableViaWWAN:{
            self.networkStatus = ConnectionNetworkStatusReachableViaWWAN;
        }
            break;
        default:
            break;
    }
}
#pragma mark Private Initialization
- (id)init {
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.managerNetwork = [AFNetworkReachabilityManager sharedManager];
        [self.managerNetwork startMonitoring];
        NotifReg(self, @selector(handleConnectionWithNotifi:), AFNetworkingReachabilityDidChangeNotification);
        
    }
    
    return self;
}
@end
