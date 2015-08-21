//
//  LocalDataBase.h
//  Zuus
//
//  Created by Vo Minh Thong on 5/30/15.
//  Copyright (c) 2015 Evizi. All rights reserved.
//

#import "ANACoreDataStoreage.h"
#import <Foundation/Foundation.h>
#import "SQLiteExport.h" 

@interface LocalDataBase : ANACoreDataStoreage <SQLiteExportStoreage>
{
    NSString *dataBaseEntityName;
}
+ (instancetype)sharedInstance;
@property (nonatomic,strong) NSString *dataBaseEntityName;
- (NSEntityDescription *)dataBaseEntity:(NSManagedObjectContext *)moc;

@end
