//
//  Singer.h
//  ANA
//
//  Created by Minh Thong on 8/21/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Singer : NSManagedObject

@property (nonatomic) int16_t idSinger;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * namejp;
@property (nonatomic) int16_t type;
@property (nonatomic) float hoterate;

@end
