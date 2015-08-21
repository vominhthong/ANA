//
//  LocalDataBase.m
//  Zuus
//
//  Created by Vo Minh Thong on 5/30/15.
//  Copyright (c) 2015 Evizi. All rights reserved.
//  

#import "LocalDataBase.h"
#import "ANACoreDataStorageProtected.h"
#import "Constants.h"
#import "Singer.h"

@implementation LocalDataBase
@synthesize dataBaseEntityName;
#define return_from_block               return

static LocalDataBase *sharedInstance;

#pragma mark - Initialize
-(NSString *)dataBaseEntityName{
    __block NSString *result = nil;
    
    dispatch_block_t block = ^{
        result = dataBaseEntityName;
    };
    
    if (dispatch_get_specific(storageQueueTag))
        block();
    else
        dispatch_sync(storageQueue, block);
    
    return result;
}

- (void)setDataBaseEntityName:(NSString *)entityName
{
    dispatch_block_t block = ^{
        dataBaseEntityName = entityName;
    };
    
    if (dispatch_get_specific(storageQueueTag))
        block();
    else
        dispatch_async(storageQueue, block);
}


-(void)clearAllResponseOnMainThread{
    
}
-(void)insertToCoreData:(void (^)(void))callback{
    [self scheduleBlock:^{
        NSManagedObjectContext *manageContext = [self managedObjectContext];
        NSEntityDescription *entity = [self dataBaseEntity:manageContext];
        
        
        NSString *bundleSQLite = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kNameSQLite];
        sqlite3_stmt *statement;
        sqlite3 *ppDB;
        if (sqlite3_open([bundleSQLite UTF8String], &ppDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM singer"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(ppDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int idSinger = sqlite3_column_int(statement, 0);
                    NSString *nameSinger = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *nameJP = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    int type = sqlite3_column_int(statement, 3);
                    int hotRate = sqlite3_column_int(statement, 4);
                    
                    Singer *singer = (Singer*)[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:manageContext];
                    singer.name = nameSinger;
                    singer.namejp = nameJP;
                    singer.type = type;
                    singer.idSinger = idSinger;
                    singer.hoterate = hotRate;
                    
                    NSError*error = nil;
                    [manageContext save:&error];
                    if (error) {
                        NSLog(@"Error : %@",error.localizedDescription);
                    }
                }
            }
            sqlite3_close(ppDB);
            
            callback();
        }else{
            NSLog(@"Failed");
        }

    }];
    
}

#pragma mark - DataBase Enity
- (NSEntityDescription *)dataBaseEntity:(NSManagedObjectContext *)moc{
    return [NSEntityDescription entityForName:[self dataBaseEntityName] inManagedObjectContext:moc];
}

#pragma mark - Share Instance
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[LocalDataBase alloc] initWithDatabaseFilename:@"Song_CoreData" storeOptions:nil];
        
    });
    
    return sharedInstance;
}
- (void)commonInit
{
    [super commonInit];
    dataBaseEntityName = @"Singer";
}

@end
