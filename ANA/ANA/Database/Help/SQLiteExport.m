//
//  SQLiteExport.m
//  ANA
//
//  Created by Minh Thong on 8/21/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "SQLiteExport.h"
#import "Constants.h"
#import "ANACoreDataStoreage.h"
#import "LocalDataBase.h"
@interface SQLiteExport () {
    dispatch_queue_t exportQueue;
    void *exportQueueTag;
    LocalDataBase *localDatabase;
    __strong id <SQLiteExportStoreage> sqliteExportStoreage;

}
@end

@implementation SQLiteExport
-(instancetype)init{
    if (self = [super init]) {
        exportQueueTag = &exportQueueTag;
        exportQueue = dispatch_queue_create("SQLiteExport", DISPATCH_QUEUE_SERIAL);
        dispatch_queue_set_specific(exportQueue, exportQueueTag, exportQueueTag, NULL);
        
        localDatabase = [LocalDataBase sharedInstance];
        
        sqliteExportStoreage = localDatabase;
    }
    return self;
}
-(void)exportSQLiteToLog:(void (^)(void))callback{
    
    dispatch_block_t block = ^{
        [sqliteExportStoreage insertToCoreData:callback];
    };
    if (dispatch_get_specific(exportQueueTag)) {
        block();
    }else{
        dispatch_async(exportQueue, block);
    }
}
@end
