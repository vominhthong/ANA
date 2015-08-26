//
//  MainViewController.m
//  ANA
//
//  Created by Minh Thong on 8/20/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//


#import "MainViewController.h"
#import "SQLiteExport.h"
#import "CollectionViewCellSinger_iPad.h"
#import "Constants.h"
#import <CoreData/CoreData.h>
#import "LocalDataBase.h"
#import "Singer.h"
#import "Song.h"
#import "TableViewCellSong_iPad.h"
#import "SongType.h"
#import "ScanLANIP.h"
#import "TableViewCellSong_iPhone.h"
#import "MorinitoringMemory.h"

typedef enum {
    CollectionViewCellSinger_iPadTypeUnknow = 0,
    CollectionViewCellSinger_iPadTypeSinger = 1,
    CollectionViewCellSinger_iPadTypeSongType
}CollectionViewCellSinger_iPadType;

typedef enum {
    TableViewSong_iPhoneSong = 0,
    TableViewSong_iPhoneSinger,
    TableViewSong_iPhoneType
}TableViewSong_iPhone;

@interface MainViewController () <UICollectionViewDataSource,UICollectionViewDelegate,NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ScanLANIPDelegate>{
    dispatch_semaphore_t semaphore;
    SQLiteExport *sqliteExport;

}
@property (nonatomic,strong) NSMutableArray *arrSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSongs;
@property (nonatomic) CollectionViewCellSinger_iPadType collectionViewCellType;
@property (nonatomic) TableViewSong_iPhone tableViewSong_iPhone;

@property (nonatomic,strong) ScanLANIP *_scanLanIPTool;
@end

@implementation MainViewController

#pragma mark - Initialize
-(NSMutableArray *)arrSingers{
    if (!_arrSingers) {
        _arrSingers = [[NSMutableArray alloc]init];
    }
    return _arrSingers;
}
#pragma mark - IBAction
-(IBAction)didTouchedSong:(id)sender{
    __weak typeof(self)wSelf = self;
    self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
    
    [sqliteExport excuteBlockInBackground:^{
        wSelf.fetchResultSongs = nil;
        [wSelf.tableView_iPhone reloadData];
        [wSelf fetchResultsSongs];
    }];
}

-(IBAction)didTouchedSongType:(id)sender{
    __weak typeof(self)wSelf = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.fetchResultSingers = nil;
        self.collectionViewCellType = CollectionViewCellSinger_iPadTypeSongType;
        
        [self.collectionView_iPad reloadData];
        
        [sqliteExport exportSongTypeSQLiteToLog:^{
            [wSelf fetchResultsSongType];
        }];
    }else{
        self.tableViewSong_iPhone = TableViewSong_iPhoneType;
        
        [sqliteExport excuteBlockInBackground:^{
            wSelf.fetchResultSongs = nil;
            [wSelf.tableView_iPhone reloadData];
            wSelf.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:[wSelf fetchRequestSongType] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:@"SongType"];
            wSelf.fetchResultSongs.delegate = wSelf;
            NSError *error = nil;
            if (![wSelf.fetchResultSongs performFetch:&error]) {
                NSLog(@"Error :%@",error.localizedDescription);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.tableView_iPhone reloadData];
            });
        }];
    }
    
}
-(IBAction)didTouchedSinger:(id)sender{
     __weak typeof(self)wSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.fetchResultSingers = nil;
        self.collectionViewCellType = CollectionViewCellSinger_iPadTypeSinger;
        [self.collectionView_iPad reloadData];
        [sqliteExport exportSQLiteToLog:^{
            [wSelf fetchResultsSinger];
        }];
    }else{
        self.tableViewSong_iPhone = TableViewSong_iPhoneSinger;
        
        [sqliteExport excuteBlockInBackground:^{
            wSelf.fetchResultSongs = nil;
            [wSelf.tableView_iPhone reloadData];
            wSelf.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:[wSelf fetchRequestSinger] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:@"Single"];
            wSelf.fetchResultSongs.delegate = wSelf;
            NSError *error = nil;
            if (![wSelf.fetchResultSongs performFetch:&error]) {
                NSLog(@"Error :%@",error.localizedDescription);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [wSelf.tableView_iPhone reloadData];
            });
        }];
    }
}
#pragma mark - Config View
-(void)configCollectionView{
    [self.collectionView_iPad registerClass:[CollectionViewCellSinger_iPad class] forCellWithReuseIdentifier:@"CollectionViewCellSinger_iPad"];
    [self.collectionView_iPad registerNib:[UINib nibWithNibName:@"CollectionViewCellSinger_iPad" bundle:nil] forCellWithReuseIdentifier:@"CollectionViewCellSinger_iPad"];
}
-(void)configTableView{
    [self.tableView_iPad registerClass:[TableViewCellSong_iPad class] forCellReuseIdentifier:@"TableViewCellSong_iPad"];
    [self.tableView_iPad registerNib:[UINib nibWithNibName:@"TableViewCellSong_iPad" bundle:nil] forCellReuseIdentifier:@"TableViewCellSong_iPad"];
    self.tableView_iPad.rowHeight = 92;
    self.tableView_iPad.backgroundColor = [UIColor clearColor];
    
    [self.tableView_iPhone registerClass:[TableViewCellSong_iPhone class] forCellReuseIdentifier:@"TableViewCellSong_iPhone"];
    [self.tableView_iPhone registerNib:[UINib nibWithNibName:@"TableViewCellSong_iPhone" bundle:nil] forCellReuseIdentifier:@"TableViewCellSong_iPhone"];
    self.tableView_iPhone.rowHeight = 60;
    self.tableView_iPhone.backgroundColor = [UIColor clearColor];
    
}
-(void)configIndicatorView{
    self.indicatorViewTableView_iPad.hidesWhenStopped = YES;
    [self.indicatorViewTableView_iPad startAnimating];
}
#pragma mark - Fetch Result

-(void)fecthResultsSingerWithPredicate:(NSFetchRequest*)fetchRequest{
    self.fetchResultSingers = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:nil];
    self.fetchResultSingers.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSingers performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.collectionView_iPad reloadData];
    });
}
-(void)fetchResultsSinger{
    self.fetchResultSingers = [[NSFetchedResultsController alloc]initWithFetchRequest:[self fetchRequestSinger] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:@"Single"];
    self.fetchResultSingers.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSingers performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.collectionView_iPad reloadData];
    });
}
-(NSFetchRequest*)fetchRequestSingerWithKey:(NSString*)key{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntity:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"name == %@",key];
    return fetchRequest;
}
-(NSFetchRequest*)fetchRequestSinger{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntity:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    return fetchRequest;
}
-(void)fetchResultsSongsWithRequest:(NSFetchRequest*)request{
    self.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchResultSongs.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSongs performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.tableView_iPad reloadData];
        [wSelf.tableView_iPhone reloadData];
        [wSelf.indicatorViewTableView_iPad stopAnimating];
    });
}
-(NSFetchRequest*)fetchRequestSongWithKey:(NSString*)key{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongs:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"songName == %@",key];
    return fetchRequest;
}

-(void)fetchResultsSongs{
    self.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:[self fetchRequestSongs] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:@"Song"];
    self.fetchResultSongs.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSongs performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.tableView_iPad reloadData];
        [wSelf.tableView_iPhone reloadData];
        [wSelf.indicatorViewTableView_iPad stopAnimating];
    });
}
-(unsigned long long)getPhysicalMemoryValue{
    NSProcessInfo *pinfo = [NSProcessInfo processInfo];
    return [pinfo physicalMemory];
}
-(NSFetchRequest*)fetchRequestSongsWithEntityName:(NSString*)entityName{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongs:[localDatabase managedObjectContext] andName:entityName];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    return fetchRequest;
}
-(NSFetchRequest*)fetchRequestSongs{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongs:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    return fetchRequest;
}

-(void)fetchResultsSongType{
    self.fetchResultSingers = [[NSFetchedResultsController alloc]initWithFetchRequest:[self fetchRequestSongType] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:@"SongType"];
    self.fetchResultSingers.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSingers performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.collectionView_iPad reloadData];
    });
}
-(NSFetchRequest*)fetchRequestSongType{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongType:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"typeName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    return fetchRequest;
}

-(void)fetchResultSongWithSingerName:(NSString*)singerName{
    self.fetchResultSongs = nil;
    [self.tableView_iPad reloadData];
    [self.tableView_iPhone reloadData];
    
    __weak typeof(self)wSelf = self;
    [sqliteExport excuteBlockInBackground:^{
        NSFetchRequest *fetchRequest = [wSelf fetchRequestSongs];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"singerName == %@",singerName];
        wSelf.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        wSelf.fetchResultSongs.delegate = wSelf;
        NSError *error = nil;
        if (![wSelf.fetchResultSongs performFetch:&error]) {
            NSLog(@"Error :%@",error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf.tableView_iPad reloadData];
            [wSelf.tableView_iPhone reloadData];
            [wSelf.indicatorViewTableView_iPad stopAnimating];
        });
    }];
}



-(void)fetchResultSongWithTypeName:(NSString*)typeName{
    self.fetchResultSongs = nil;
    [self.tableView_iPad reloadData];
    [self.tableView_iPhone reloadData];
    __weak typeof(self)wSelf = self;
    [sqliteExport excuteBlockInBackground:^{
        NSFetchRequest *fetchRequest = [wSelf fetchRequestSongsWithEntityName:typeName];
        wSelf.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        wSelf.fetchResultSongs.delegate = wSelf;
        NSError *error = nil;
        if (![wSelf.fetchResultSongs performFetch:&error]) {
            NSLog(@"Error :%@",error.localizedDescription);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [wSelf.tableView_iPad reloadData];
            [wSelf.tableView_iPhone reloadData];
            [wSelf.indicatorViewTableView_iPad stopAnimating];
        });
    }];
}
#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{


    [textField resignFirstResponder];
    __weak typeof(self)wSelf = self;
    if (textField == self.txtSearchSingerName) {
        [sqliteExport excuteBlockInBackground:^{
            wSelf.fetchResultSingers = nil;
            [wSelf.collectionView_iPad reloadData];
            NSString *searchKey = textField.text;
            if (searchKey.length == 0) {
                [wSelf fetchResultsSinger];
            }else{
                [wSelf fecthResultsSingerWithPredicate:[wSelf fetchRequestSingerWithKey:searchKey]];
            }
        }];
    }else{
        [sqliteExport excuteBlockInBackground:^{
            wSelf.fetchResultSongs = nil;
            [wSelf.tableView_iPad reloadData];
            [wSelf.tableView_iPhone reloadData];
            NSString *searchKey = textField.text;
            if (searchKey.length == 0) {
                [wSelf fetchResultsSongs];
            }else{
                [wSelf fetchResultsSongsWithRequest:[wSelf fetchRequestSongWithKey:searchKey]];
            }
        }];
    }


    return YES;
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
#pragma mark - ScanLANIP Delegate
-(void)scanLANIPDidConnectToANA:(ConnectTCP *)socket{
    
}
#pragma mark - Init life vehicle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self._scanLanIPTool = [ScanLANIP shareInstance];
    self._scanLanIPTool.delegate = self;
    [self._scanLanIPTool startScanIPInLan];
    
    self.collectionViewCellType = CollectionViewCellSinger_iPadTypeSinger;
    sqliteExport = [[SQLiteExport alloc]init];
    self.txtSearchSingerName.delegate = self;
    self.txtSearchSongName.delegate = self;
    
    self.txtSearchSongName.returnKeyType = UIReturnKeyDone;
    self.txtSearchSingerName.returnKeyType = UIReturnKeyDone;
    if (!semaphore) {
        semaphore = dispatch_semaphore_create(0);
    }
    __weak typeof(self) wSelf = self;
    [self configTableView];
    [self configCollectionView];
    [self configIndicatorView];

    [sqliteExport exportSQLiteToLog:^{
        [wSelf fetchResultsSinger];
        dispatch_semaphore_signal(semaphore);
    }];

    [sqliteExport exportSongTypeSQLiteToLog:^{
        
    }];
    
    [sqliteExport exportSongGouYuSQLToLog:^{
        
    }];
    
    [sqliteExport exportSongSQLiteToLog:^{
        [wSelf fetchResultsSongs];
    }];
    [self getPhysicalMemoryValue];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    MorinitoringMemory *morinitor = [[MorinitoringMemory alloc]init];
    [morinitor startMornitoringRAMWithTimer:5];
    
    // Do any additional setup after loading the view.
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.fetchResultSongs.sections.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.fetchResultSongs.sections objectAtIndex:section] numberOfObjects];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        TableViewCellSong_iPad *cell = [self.tableView_iPad dequeueReusableCellWithIdentifier:@"TableViewCellSong_iPad" forIndexPath:indexPath];
        Song *song = [self.fetchResultSongs objectAtIndexPath:indexPath];
        cell.lbName.text = [song.songName uppercaseString];
        cell.lbSingerName.text = song.singerName;
        if (indexPath.row % 2== 1) {
            cell.backgroundCell.alpha = 0.6;
        }else{
            cell.backgroundCell.alpha = 0.9;
        }
        return cell;
    }else{
        TableViewCellSong_iPhone *cell = [self.tableView_iPhone dequeueReusableCellWithIdentifier:@"TableViewCellSong_iPhone" forIndexPath:indexPath];
        switch (self.tableViewSong_iPhone) {
            case TableViewSong_iPhoneSinger:
            {
                Singer *singer = [self.fetchResultSongs objectAtIndexPath:indexPath];
                cell.lbName.text = singer.name;
            }
                break;
            case TableViewSong_iPhoneSong:{
                Song *song = [self.fetchResultSongs objectAtIndexPath:indexPath];
                cell.lbName.text = [song.songName uppercaseString];
                cell.lbSingerName.text = song.singerName;
            }
                break;
            case TableViewSong_iPhoneType:{
                SongType *songType = [self.fetchResultSongs objectAtIndexPath:indexPath];
                cell.lbName.text = songType.typeName;
            }
                break;
            default:
                break;
        }
        
        if (indexPath.row % 2== 1) {
            cell.backgroundCell.alpha = 0.6;
        }else{
            cell.backgroundCell.alpha = 0.9;
        }
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && !self.tableViewSong_iPhone == TableViewSong_iPhoneSong) {
        __weak typeof(self)wSelf = self;
        switch (self.tableViewSong_iPhone) {
            case TableViewSong_iPhoneSinger:
            {
                self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
                Singer *singer = [self.fetchResultSongs objectAtIndexPath:indexPath];
                [wSelf fetchResultSongWithSingerName:singer.name];
                
            }
                break;
            case TableViewSong_iPhoneType:{
                self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
                SongType *songType = [self.fetchResultSongs objectAtIndexPath:indexPath];
                [wSelf fetchResultSongWithTypeName:songType.tableName];
            }
                
            default:
                break;
        }
    }
}
#pragma mark - UICollectionViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.fetchResultSingers.sections.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [[self.fetchResultSingers.sections objectAtIndex:section] numberOfObjects];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCellSinger_iPad *singerCell = [self.collectionView_iPad dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellSinger_iPad" forIndexPath:indexPath];
    
    switch (self.collectionViewCellType) {
        case CollectionViewCellSinger_iPadTypeSinger:{
            Singer *singer = [self.fetchResultSingers objectAtIndexPath:indexPath];
            singerCell.lbSingerName.text = singer.name;
        }
            
            break;
        case CollectionViewCellSinger_iPadTypeSongType:{
            SongType *songType = [self.fetchResultSingers objectAtIndexPath:indexPath];
            singerCell.lbSingerName.text = songType.typeName;
        }
            
        default:
            break;
    }

    return singerCell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.collectionViewCellType) {
        case CollectionViewCellSinger_iPadTypeSongType:
        {
            SongType *songType = [self.fetchResultSingers objectAtIndexPath:indexPath];
            __weak typeof(self)wSelf = self;
            self.fetchResultSongs = nil;
            [self.tableView_iPad reloadData];
            [self.tableView_iPhone reloadData];
            if ([songType.typeName isEqualToString:@"ALL"]) {
                
                [sqliteExport excuteBlockInBackground:^{
                    [wSelf fetchResultsSongs];
                }];
            }else{
                [sqliteExport excuteBlockInBackground:^{
                    [wSelf fetchResultSongWithTypeName:songType.tableName];
                }];
            }
        }
            break;
        case CollectionViewCellSinger_iPadTypeSinger:{
            Singer *singer = [self.fetchResultSingers objectAtIndexPath:indexPath];
            [self fetchResultSongWithSingerName:singer.name];
        }
            break;
        default:
            break;
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(CELLSINGER_WIDTH, CELLSINGER_HEIGHT);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
