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
-(void)insertSongsToCoreData:(void(^)(void))callback;
-(void)insertSongTypeToCoreData:(void (^)(void))callback;
-(void)insertSongGouYuToCoreData:(void(^)(void))callback;
-(void)excuteThreadInBackground:(void(^)(void))callback;

@end

@interface SQLiteExport : NSObject
-(void)exportSQLiteToLog:(void (^)(void))callback;
-(void)exportSongSQLiteToLog:(void (^)(void))callback;
-(void)exportSongTypeSQLiteToLog:(void (^)(void))callback;
-(void)exportSongGouYuSQLToLog:(void(^)(void))callback;

-(void)excuteBlockInBackground:(void(^)(void))callback;
@end
