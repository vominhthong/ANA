//
//  Song.h
//  ANA
//
//  Created by Minh Thong on 8/22/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Song : NSManagedObject

@property (nonatomic) int16_t idSong;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songNameJP;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic) int16_t hotRate;
@property (nonatomic) int16_t pftype;

@end
