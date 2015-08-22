//
//  ANACoreDataStoreage.h
//  ANA
//
//  Created by Vo Minh Thong on 5/30/15.
//  Copyright (c) 2015 Evizi. All rights reserved.
//  This class from libXMPPService project, it base on xmpp framework

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>
#import <CoreData/CoreData.h>

@interface ANACoreDataStoreage : NSObject
{
@private

    NSMutableDictionary *myJidCache;
    
    int32_t pendingRequests;
    
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectContext *mainThreadManagedObjectContext;
    
    NSMutableArray *willSaveManagedObjectContextBlocks;
    NSMutableArray *didSaveManagedObjectContextBlocks;
    
    
@public
    
    NSString *databaseFileName;
    NSDictionary *storeOptions;
    NSUInteger saveThreshold;
    NSUInteger saveCount;
    
    BOOL autoRemovePreviousDatabaseFile;
    BOOL autoRecreateDatabaseFile;
    BOOL autoAllowExternalBinaryDataStorage;
    
    dispatch_queue_t storageQueue;
    void *storageQueueTag;
}

- (id)initWithDatabaseFilename:(NSString *)databaseFileName storeOptions:(NSDictionary *)storeOptions;


- (id)initWithInMemoryStore;


@property (readonly) NSString *databaseFileName;

@property (readonly) NSDictionary *storeOptions;

@property (readwrite) NSUInteger saveThreshold;

@property (strong, readonly) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, readonly) NSManagedObjectContext *managedObjectContext;

@property (strong, readonly) NSManagedObjectContext *mainThreadManagedObjectContext;


@property (readwrite) BOOL autoRemovePreviousDatabaseFile;

@property (readwrite) BOOL autoRecreateDatabaseFile;

@property (readwrite) BOOL autoAllowExternalBinaryDataStorage;
@end
