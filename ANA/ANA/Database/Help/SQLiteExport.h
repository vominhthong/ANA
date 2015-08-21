//
//  SQLiteExport.h
//  ANA
//
//  Created by Minh Thong on 8/21/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class SQLiteExport;
@protocol SQLiteExportStoreage <NSObject>

-(BOOL)configureWithParent:(SQLiteExport *)aParent queue:(dispatch_queue_t)queue;

-(void)insertToCoreData:(void(^)(void))callback;

@end

@interface SQLiteExport : NSObject
-(void)exportSQLiteToLog:(void (^)(void))callback;

@end
