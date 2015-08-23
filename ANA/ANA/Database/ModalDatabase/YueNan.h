//
//  YueNan.h
//  ANA
//
//  Created by Minh Thong on 8/23/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YueNan : NSManagedObject

@property (nonatomic) int16_t hotRate;
@property (nonatomic) int16_t idSong;
@property (nonatomic) int16_t pftype;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songNameJP;

@end
