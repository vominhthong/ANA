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
#import "Song.h"
#import "SongType.h"
#import "GuoYu.h"

@implementation LocalDataBase
@synthesize dataBaseEntityName;
#define return_from_block               return

static LocalDataBase *sharedInstance;

-(void)excuteThreadInBackground:(void (^)(void))callback{
    [self scheduleBlock:callback];
}
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


-(void)insertSongTypeToCoreData:(void (^)(void))callback{
    [self scheduleBlock:^{
        NSManagedObjectContext *manageContext = [self managedObjectContext];
        NSEntityDescription *entity = [self dataBaseEntitySongType:manageContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        fetchRequest.entity = entity;
        NSError *error = nil;
        NSUInteger count = [manageContext countForFetchRequest:fetchRequest error:&error];
        if (count > 0) {
            callback();
            return ;
        }else if (error){
            callback();
            return;
        }
        
        NSString *bundleSQLite = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kNameSQLite];
        sqlite3_stmt *statement;
        sqlite3 *ppDB;
        if (sqlite3_open([bundleSQLite UTF8String], &ppDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM songtype"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(ppDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int type = sqlite3_column_int(statement, 0);
                    NSString *typeName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *tableName = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    int flag = sqlite3_column_int(statement, 3);
                    int pftype = sqlite3_column_int(statement, 4);
                    
                    SongType *songType = (SongType*)[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:manageContext];
                    songType.type = [NSNumber numberWithInt:type];
                    songType.typeName = typeName;
                    songType.tableName = tableName;
                    songType.flag = [NSNumber numberWithBool:flag];
                    songType.pftype = [NSNumber numberWithInt:pftype];
                    
                    NSError*error = nil;
                    [manageContext insertObject:songType];
                    if (error) {
                        NSLog(@"Error : %@",error.localizedDescription);
                    }
                }
            }
            sqlite3_close(ppDB);
            callback();
        }else{
            callback();
            NSLog(@"Failed");
        }
    }];
}
-(void)insertSongGouYuToCoreData:(void (^)(void))callback{
    [self insertSongsToCoreDataWithTableName:@"GuoYu" entityName:@"GuoYu" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"LiuXing" entityName:@"LiuXing" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"QingGe" entityName:@"QingGe" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"ZuHe" entityName:@"ZuHe" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"YueYu" entityName:@"YueYu" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"Zong" entityName:@"Zong" withCallback:callback];
    [self insertSongsToCoreDataWithTableName:@"YueNan" entityName:@"YueNan" withCallback:callback];


}
-(void)insertSongsToCoreDataWithTableName:(NSString*)tableName
                               entityName:(NSString*)entityName
                             withCallback:(void (^)(void))callback{
    [self scheduleBlock:^{
        NSManagedObjectContext *manageContext = [self managedObjectContext];
        NSEntityDescription *entity = [self dataBaseEntitySongs:manageContext andName:entityName];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        fetchRequest.entity = entity;
        NSError *error = nil;
        NSUInteger count = [manageContext countForFetchRequest:fetchRequest error:&error];
        if (count > 0) {
            callback();
            return ;
        }else if (error){
            callback();
            return;
        }
        NSString *bundleSQLite = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kNameSQLite];
        sqlite3_stmt *statement;
        sqlite3 *ppDB;
        if (sqlite3_open([bundleSQLite UTF8String], &ppDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM %@",tableName];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(ppDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int idSong = sqlite3_column_int(statement, 0);
                    NSString *nameSong = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *nameJPSong = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];
                    NSString *nameSinger = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 7)];
                    int hotRate = sqlite3_column_int(statement, 10);
                    
                    Song *song = (Song*)[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:manageContext];
                    song.songName = nameSong;
                    song.songNameJP = nameJPSong;
                    song.hotRate = [NSNumber numberWithInt:hotRate];
                    song.idSong = [NSString stringWithFormat:@"%i",idSong];
                    song.singerName = nameSinger;
                    
                    NSError*error = nil;
                    [manageContext insertObject:song];
                    if (error) {
                        NSLog(@"Error : %@",error.localizedDescription);
                    }
                }
            }
            sqlite3_close(ppDB);
            callback();
        }else{
            callback();
            NSLog(@"Failed");
        }
        
    }];
}

-(void)insertSongsToCoreData:(void (^)(void))callback{
    [self scheduleBlock:^{
        NSManagedObjectContext *manageContext = [self managedObjectContext];
        NSEntityDescription *entity = [self dataBaseEntitySongs:manageContext];
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        fetchRequest.entity = entity;
        NSError *error = nil;
        NSUInteger count = [manageContext countForFetchRequest:fetchRequest error:&error];
        if (count > 0) {
            callback();
            return ;
        }else if (error){
            callback();
            return;
        }
        NSString *bundleSQLite = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kNameSQLite];
        sqlite3_stmt *statement;
        sqlite3 *ppDB;
        if (sqlite3_open([bundleSQLite UTF8String], &ppDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat: @"SELECT * FROM song"];
            const char *query_stmt = [querySQL UTF8String];
            
            if (sqlite3_prepare_v2(ppDB, query_stmt, -1, &statement, NULL) == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    int idSong = sqlite3_column_int(statement, 0);
                    NSString *nameSong = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 1)];
                    NSString *nameSongUnicode = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 2)];

                    NSString *nameJPSong = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,3)];
                    NSString *nameSinger = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 8)];
                    int hotRate = sqlite3_column_int(statement, 8);
                    
                    Song *song = (Song*)[[NSManagedObject alloc]initWithEntity:entity insertIntoManagedObjectContext:manageContext];
                    song.songName = nameSong;
                    song.songNameJP = nameJPSong;
                    song.hotRate = [NSNumber numberWithInt:hotRate];
                    song.idSong = [NSString stringWithFormat:@"%i",idSong];
                    song.singerName = nameSinger;
                    song.songNameUnicode =  nameSongUnicode;
                    [manageContext insertObject:song];
                    if (error) {
                        NSLog(@"Error : %@",error.localizedDescription);
                    }
                }
            }
            sqlite3_close(ppDB);
            callback();
        }else{
            callback();
            NSLog(@"Failed");
        }
        
    }];
}
-(void)insertToCoreData:(void (^)(void))callback{
    [self scheduleBlock:^{
        NSManagedObjectContext *manageContext = [self managedObjectContext];
        NSEntityDescription *entity = [self dataBaseEntity:manageContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
        fetchRequest.entity = entity;
        NSError *error = nil;
        NSUInteger count = [manageContext countForFetchRequest:fetchRequest error:&error];
        if (count > 0) {
            callback();
            return ;
        }else if (error){
            callback();
        }
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
                    singer.type = [NSNumber numberWithInt:type];
                    singer.idSinger = [NSString stringWithFormat:@"%i",idSinger];
                    singer.hoterate = [NSNumber numberWithInt:hotRate];
                    
                    NSError*error = nil;
                    [manageContext insertObject:singer];
                    if (error) {
                        NSLog(@"Error : %@",error.localizedDescription);
                    }
                }
            }
            sqlite3_close(ppDB);
            callback();
        }else{
            callback();
            NSLog(@"Failed");
        }

    }];
    
}

#pragma mark - DataBase Enity
- (NSEntityDescription *)dataBaseEntity:(NSManagedObjectContext *)moc{
    return [NSEntityDescription entityForName:[self dataBaseEntityName] inManagedObjectContext:moc];
}
- (NSEntityDescription *)dataBaseEntitySongs:(NSManagedObjectContext *)moc andName:(NSString*)name{
    return [NSEntityDescription entityForName:name inManagedObjectContext:moc];
}
- (NSEntityDescription *)dataBaseEntitySongs:(NSManagedObjectContext *)moc{
    return [NSEntityDescription entityForName:@"Songs" inManagedObjectContext:moc];
}
- (NSEntityDescription *)dataBaseEntitySongType:(NSManagedObjectContext *)moc{
    return [NSEntityDescription entityForName:@"SongType" inManagedObjectContext:moc];
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
