//
//  NSMutableData+HashPacketANA.m
//  ANA
//
//  Created by Minh Thong on 8/26/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "NSMutableData+HashPacketANA.h"

@implementation NSMutableData (HashPacketANA)
-(NSMutableData*)hasPacketAna{
    NSMutableData *newData = [NSMutableData data];
    /* add 8 bytes into header */
    const char *charKM = [@"KM" UTF8String];
    [newData appendBytes:charKM length:2];
    
    NSUInteger i = self.length;
    NSData *lenghtData = [NSData dataWithBytes:&i length:1];
    [newData appendData:lenghtData];
    
    NSData *byteDefault = [NSData dataWithBytes:(unsigned char[]){0x00,0x00,0x00} length:3];
    [newData appendData:byteDefault];
    
    NSData *doubleSpace = [NSData dataWithBytes:(const char*)[@"  " UTF8String] length:2];
    [newData appendData:doubleSpace];
    
    [newData appendData:self];
    return newData;
}
@end
