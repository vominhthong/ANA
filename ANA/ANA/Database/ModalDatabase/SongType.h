//
//  SongType.h
//  ANA
//
//  Created by Minh Thong on 8/22/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SongType : NSManagedObject

@property (nonatomic) int16_t type;
@property (nonatomic, retain) NSString * typeName;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic) int16_t flag;
@property (nonatomic) int16_t pftype;

@end
