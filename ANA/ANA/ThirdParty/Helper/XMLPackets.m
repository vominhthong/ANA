//
//  XMLPackets.m
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "XMLPackets.h"
#import "NSXMLElement+XMPP.h"
@implementation XMLPackets
-(NSXMLElement*)defaultHeaderPacket{
    NSXMLElement *headTag = [NSXMLElement elementWithName:@"head"];
    [headTag addAttributeWithName:@"fromip" stringValue:@"192.168.0.1"];
    [headTag addAttributeWithName:@"packtype" stringValue:@"32"];
    [headTag addAttributeWithName:@"sessionid" stringValue:@"9472"];
    [headTag addAttributeWithName:@"version" stringValue:@"1"];
    return headTag;
}


-(NSXMLElement *)getBindingCodeToIPAna:(NSString*)ip{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *headTag = [self defaultHeaderPacket];
    [headTag addAttributeWithName:@"toip" stringValue:ip];

    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E420"];
    
    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];
    return messageTag;
}


-(NSXMLElement *)pauseWithIP:(NSString *)ip roomBindingCode:(NSString *)bindingCode{
    return [self packetXMLDataWithControlType:@"10"
                             andControllValue:@"1"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)replayWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"10"
                             andControllValue:@"3"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)nextWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"10"
                             andControllValue:@"2"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)lipsWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"10"
                             andControllValue:@"4"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)muteWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"20"
                             andControllValue:@"10"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)drumWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"22"
                             andControllValue:@"3"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)clapWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"22"
                             andControllValue:@"4"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)thumbUPWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"22"
                             andControllValue:@"1"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)thumbDownWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"22"
                             andControllValue:@"2"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)volumeUpWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"20"
                             andControllValue:@"3"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)volumeDownWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:@"20"
                             andControllValue:@"4"
                                     andCMDID:@"E400"
                                         toIp:ip
                                  bindingCode:bindingCode];
}

-(NSXMLElement *)volumeDefaultWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode{
    return [self packetXMLDataWithControlType:nil
                             andControllValue:nil
                                     andCMDID:@"E420"
                                         toIp:ip
                                  bindingCode:bindingCode];
}
-(NSXMLElement *)selectSongWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *headTag = [self defaultHeaderPacket];
    [headTag addAttributeWithName:@"toip" stringValue:ip];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E400"];
    [bodyTag addAttributeWithName:@"roombindingcode" stringValue:bindingCode];
    [bodyTag addAttributeWithName:@"controltype" stringValue:@"40"];
    [bodyTag addAttributeWithName:@"controlvalue" stringValue:idSong];
    [bodyTag addAttributeWithName:@"kp" stringValue:@"0"];

    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];
    
    return messageTag;
}
-(NSXMLElement *)pushSongTopWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *headTag = [self defaultHeaderPacket];
    [headTag addAttributeWithName:@"toip" stringValue:ip];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E400"];
    [bodyTag addAttributeWithName:@"roombindingcode" stringValue:bindingCode];
    [bodyTag addAttributeWithName:@"controltype" stringValue:@"41"];
    [bodyTag addAttributeWithName:@"controlvalue" stringValue:idSong];
    [bodyTag addAttributeWithName:@"kp" stringValue:@"0"];
    
    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];
    
    return messageTag;
}
-(NSXMLElement *)chooseSongWithIP:(NSString*)ip roomBindingCode:(NSString*)bindingCode withId:(NSString*)idSong{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *headTag = [self defaultHeaderPacket];
    [headTag addAttributeWithName:@"toip" stringValue:ip];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:@"E402"];
    [bodyTag addAttributeWithName:@"roombindingcode" stringValue:bindingCode];
    
    NSXMLElement *recordTag = [NSXMLElement elementWithName:@"records"];
    [recordTag addAttributeWithName:@"startpos" stringValue:@"0"];
    [recordTag addAttributeWithName:@"timestamp" stringValue:@"0"];
    [recordTag addAttributeWithName:@"num" stringValue:@"20"];
    
    [bodyTag addChild:recordTag];
    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];

    
    return messageTag;
}
-(NSXMLElement *)packetXMLDataWithControlType:(NSString*)type
                             andControllValue:(NSString*)value
                                     andCMDID:(NSString*)cmdid
                                         toIp:(NSString*)ip
                                  bindingCode:(NSString*)bindingCode{
    NSXMLElement *messageTag = [NSXMLElement elementWithName:@"message"];
    
    NSXMLElement *headTag = [self defaultHeaderPacket];
    [headTag addAttributeWithName:@"toip" stringValue:ip];
    
    NSXMLElement *bodyTag = [NSXMLElement elementWithName:@"body"];
    [bodyTag addAttributeWithName:@"cmdid" stringValue:cmdid];
    
    if (bindingCode) {
        [bodyTag addAttributeWithName:@"roombindingcode" stringValue:bindingCode];
    }
    if (type) {
        [bodyTag addAttributeWithName:@"controltype" stringValue:type];
    }
    if (value) {
        [bodyTag addAttributeWithName:@"controlvalue" stringValue:value];
    }
    
    
    [messageTag addChild:headTag];
    [messageTag addChild:bodyTag];
    
    return messageTag;
}
@end
