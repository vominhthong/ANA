//
//  SongType.h
//  ANA
//
//  Created by Minh Thong on 8/27/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SongType : NSManagedObject

@property (nonatomic, retain) NSNumber * flag;
@property (nonatomic, retain) NSNumber * pftype;
@property (nonatomic, retain) NSString * tableName;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * typeName;

@end
