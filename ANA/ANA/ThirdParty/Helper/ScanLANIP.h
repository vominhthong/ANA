//
//  ScanLANIP.h
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectTCP.h"
@protocol ScanLANIPDelegate <NSObject>

-(void)scanLANIPDidConnectToANA:(ConnectTCP*)socket;
-(void)scanLANIPDidFinishedScan:(ConnectTCP*)socket;
@end

@interface ScanLANIP : NSObject
+(ScanLANIP*)shareInstance;

-(void)stopScanIPInLan;

-(void)startScanIPInLan;

@property (nonatomic) id <ScanLANIPDelegate> delegate;
@end
