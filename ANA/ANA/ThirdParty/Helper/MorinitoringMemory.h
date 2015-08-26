//
//  MorinitoringMemory.h
//  ANA
//
//  Created by Minh Thong on 8/26/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MorinitoringMemory : NSObject
-(void)startMornitoringRAMWithTimer:(int)timer;
-(void)stopMornitoringRAM;
@end
