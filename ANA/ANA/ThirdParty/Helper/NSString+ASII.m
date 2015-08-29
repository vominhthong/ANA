//
//  NSString+ASII.m
//  ANA
//
//  Created by Minh Thong on 8/29/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "NSString+ASII.h"

@implementation NSString (ASII)
-(NSString*)stringToASCII{
    NSString *standard = [self stringByReplacingOccurrencesOfString:@"đ" withString:@"d"];
    standard = [standard stringByReplacingOccurrencesOfString:@"Đ" withString:@"D"];
    NSData *decode = [standard dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *ansi = [[NSString alloc] initWithData:decode encoding:NSASCIIStringEncoding];
    return ansi;
}
@end
