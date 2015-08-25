//
//  XMLPackets.h
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDXML.h"

@interface XMLPackets : NSObject

-(NSXMLElement *)getBindingCodeToIPAna:(NSString*)ip;

-(NSXMLElement *)pauseWithIP:(NSString *)ip roomBindingCode:(NSString *)bindingCode;

-(NSXMLElement *)replayWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)nextWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)lipsWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)muteWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)drumWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)clapWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)thumbUPWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)thumbDownWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)volumeUpWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)volumeDownWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)volumeDefaultWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode;

-(NSXMLElement *)selectSongWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong;

-(NSXMLElement *)pushSongTopWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong;

-(NSXMLElement *)chooseSongWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong;


@end
