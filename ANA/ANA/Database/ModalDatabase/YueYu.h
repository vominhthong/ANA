//
//  YueYu.h
//  ANA
//
//  Created by Minh Thong on 8/23/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YueYu : NSManagedObject

@property (nonatomic, retain) NSNumber * hotRate;
@property (nonatomic, retain) NSNumber * idSong;
@property (nonatomic, retain) NSNumber * pftype;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * songNameJP;

@end
