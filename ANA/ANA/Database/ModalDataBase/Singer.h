//
//  Singer.h
//  ANA
//
//  Created by Minh Thong on 8/27/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Singer : NSManagedObject

@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * namejp;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * idSinger;
@property (nonatomic, retain) NSNumber * hoterate;

@end
