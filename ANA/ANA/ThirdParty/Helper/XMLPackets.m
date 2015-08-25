//
//  XMLPackets.m
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "XMLPackets.h"

@implementation XMLPackets
+(XMLPackets *)shareInstance{
    static XMLPackets *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[XMLPackets alloc]init];
    });
    return _instance;
}
-(DDXMLElement *)getBindingCode{
    return Nil;
}
@end
