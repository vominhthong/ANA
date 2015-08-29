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
#import "ConnectTCP.h"
#import "XMLPackets.h"
#import "NSXMLElement+XMPP.h"
#import "AFNetworkReachabilityManager.h"
#import "ConnectionNetwork.h"
#import "UIView+Toast.h"
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

@interface MainViewController () <UICollectionViewDataSource,UICollectionViewDelegate,NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ScanLANIPDelegate,UIAlertViewDelegate>{
    dispatch_semaphore_t semaphore;
    SQLiteExport *sqliteExport;

}
@property (nonatomic,strong) NSMutableArray *arrSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSongs;
@property (nonatomic) CollectionViewCellSinger_iPadType collectionViewCellType;
@property (nonatomic) TableViewSong_iPhone tableViewSong_iPhone;
@property (nonatomic) BOOL  isHasNetwork;
@property (nonatomic,strong) ScanLANIP *_scanLanIPTool;
@property (nonatomic,strong) ConnectTCP *_connectTCP;
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
-(IBAction)didTouchedChoosedSong:(id)sender{
    XMLPackets *xmlPacketChoosedSong = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketChoosedSong chooseSongWithIP:self._connectTCP.hostIP roomBindingCode:self._connectTCP.roomBindingCode withId:nil] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedThumbDownButton:(id)sender{
    XMLPackets *xmlPacketClap = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketClap thumbDownWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedThumbUpButton:(id)sender{
    XMLPackets *xmlPacketClap = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketClap thumbUPWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedClapButton:(id)sender{
    XMLPackets *xmlPacketClap = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketClap clapWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedDrumButton:(id)sender{
    XMLPackets *xmlPacketDrum = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketDrum drumWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedMuteButton:(id)sender{
    XMLPackets *xmlPacketMute = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketMute muteWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedLipsButton:(id)sender{
    XMLPackets *xmlPacketLip = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketLip lipsWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedNextButton:(id)sender{
    XMLPackets *xmlPacketNext = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketNext nextWithIP:self._connectTCP.hostIP  roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedReplayButton:(id)sender{
    XMLPackets *xmlPacketReplay = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketReplay replayWithIP:self._connectTCP.hostIP roomBindingCode:self._connectTCP.roomBindingCode] compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedPlayButton:(id)sender{
    XMLPackets *xmlPacketPlay = [[XMLPackets alloc]init];
    NSString *xmlString = [[xmlPacketPlay pauseWithIP:self._connectTCP.hostIP roomBindingCode:self._connectTCP.roomBindingCode]compactXMLString];
    [self._connectTCP writeData:xmlString];
}
-(IBAction)didTouchedSong:(id)sender{
    self.btnCasi_iPhone.selected = NO;
    self.btnDaChon_iPhone.selected = NO;
    self.btnTheLoai_iPhone.selected = NO;
    self.btnBaiHat_iPhone.selected = YES;
    self.txtSearch_iPhone.text = @"";

    __weak typeof(self)wSelf = self;
    self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
    wSelf.fetchResultSongs = nil;
    [wSelf.tableView_iPhone reloadData];
    [sqliteExport excuteBlockInBackground:^{

        [wSelf fetchResultsSongs];
    }];
}

-(IBAction)didTouchedSongType:(UIButton*)sender{
    self.txtSearch_iPhone.text = @"";
    self.btnCasi_iPhone.selected = NO;
    self.btnDaChon_iPhone.selected = NO;
    self.btnTheLoai_iPhone.selected = YES;
    self.btnBaiHat_iPhone.selected = NO;
    
    __weak typeof(self)wSelf = self;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.fetchResultSingers = nil;
        self.collectionViewCellType = CollectionViewCellSinger_iPadTypeSongType;
        
        [self.collectionView_iPad reloadData];
        
        [sqliteExport exportSongTypeSQLiteToLog:^{
            [wSelf fetchResultsSongType];
        }];
    }else{
        sender.selected = YES;
        self.tableViewSong_iPhone = TableViewSong_iPhoneType;
        wSelf.fetchResultSongs = nil;
        [wSelf.tableView_iPhone reloadData];
        [sqliteExport excuteBlockInBackground:^{

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
    self.txtSearch_iPhone.text = @"";

    self.btnCasi_iPhone.selected = YES;
    self.btnDaChon_iPhone.selected = NO;
    self.btnTheLoai_iPhone.selected = NO;
    self.btnBaiHat_iPhone.selected = NO;
    
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
        wSelf.fetchResultSongs = nil;
        [wSelf.tableView_iPhone reloadData];
        [sqliteExport excuteBlockInBackground:^{

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
    if (self.fetchResultSingers.sections.count == 0) {
        [self.view makeToast:@"Không tìm thấy kết quả"];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view hideToastActivity];
        });
    }
    
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.collectionView_iPad reloadData];
    });
}
-(void)fetchResultsSinger{
    self.fetchResultSingers = [[NSFetchedResultsController alloc]initWithFetchRequest:[self fetchRequestSinger] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:nil];
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
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"((name contains[cd] %@ OR namejp contains[cd] %@) AND name BEGINSWITH[cd] %@) OR (name like[c] %@ OR namejp like[c] %@)",[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII]];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.fetchResultSongs fetchedObjects].count == 0) {
            [self.view makeToast:@"Không tìm thấy kết quả"];
        }else{
            [self.view hideToastActivity];

        }
    });
    

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
    fetchRequest.fetchBatchSize = 10;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    //SELF like[c] %@*
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"((songNameUnicode contains[cd] %@ OR songNameJP contains[cd] %@) AND songNameUnicode BEGINSWITH[cd] %@) OR (songNameUnicode like[c] %@ OR songNameJP like[c] %@)",[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII],[[key uppercaseString] stringToASCII]];
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

-(NSFetchRequest*)fetchRequestSongTypeWithKey:(NSString*)key{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongType:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"typeName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"typeName contains[cd] %@",[[key uppercaseString] stringToASCII]];
    return fetchRequest;
}
-(NSFetchRequest*)fetchRequestSongTypeWithKey_iPad:(NSString*)key{
    LocalDataBase *localDatabase = [LocalDataBase sharedInstance];
    NSEntityDescription *entity = [localDatabase dataBaseEntitySongType:[localDatabase managedObjectContext]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    fetchRequest.fetchBatchSize = 100;
    fetchRequest.entity = entity;
    NSSortDescriptor *sortDscr = [[NSSortDescriptor alloc]initWithKey:@"typeName" ascending:true];
    [fetchRequest setSortDescriptors:@[sortDscr]];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"typeName BEGINSWITH[cd] %@",[[key uppercaseString] stringToASCII]];
    return fetchRequest;
}
-(void)fetchResultsSongTypeWithFetchRequest_iPad:(NSFetchRequest*)request{
    self.fetchResultSingers = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
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
-(void)fetchResultsSongTypeWithFetchRequest:(NSFetchRequest*)request{
    self.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    self.fetchResultSongs.delegate = self;
    NSError *error = nil;
    if (![self.fetchResultSongs performFetch:&error]) {
        NSLog(@"Error :%@",error.localizedDescription);
    }
    __weak typeof(self) wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [wSelf.tableView_iPhone reloadData];
    });
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
            if (self.collectionViewCellType == CollectionViewCellSinger_iPadTypeSinger) {
                NSString *searchKey = textField.text;
                if (searchKey.length == 0) {
                    [wSelf fetchResultsSinger];
                }else{
                    [wSelf fecthResultsSingerWithPredicate:[wSelf fetchRequestSingerWithKey:searchKey]];
                }
            }else{
                
            }

        }];
    }else if (textField == self.txtSearchSongName){
        self.fetchResultSongs = nil;
        [self.tableView_iPad reloadData];
        [self.tableView_iPhone reloadData];
        [sqliteExport excuteBlockInBackground:^{

            NSString *searchKey = textField.text;
            if (searchKey.length == 0) {
                [wSelf fetchResultsSongs];
            }else{
                [wSelf fetchResultsSongsWithRequest:[wSelf fetchRequestSongWithKey:searchKey]];
            }
        }];
    }else if (textField == self.txtSearch_iPhone){

        
        if (self.tableViewSong_iPhone == TableViewSong_iPhoneSinger) {
            self.fetchResultSongs = nil;
            [self.tableView_iPhone reloadData];
            [sqliteExport excuteBlockInBackground:^{
                NSString *searchKey = textField.text;
                if (searchKey.length == 0) {
                    [wSelf didTouchedSinger:nil];
                }else{
                    wSelf.fetchResultSongs = [[NSFetchedResultsController alloc]initWithFetchRequest:[wSelf fetchRequestSingerWithKey:searchKey] managedObjectContext:[[LocalDataBase sharedInstance] managedObjectContext] sectionNameKeyPath:nil   cacheName:nil];
                    wSelf.fetchResultSongs.delegate = wSelf;
                    NSError *error = nil;
                    if (![wSelf.fetchResultSongs performFetch:&error]) {
                        NSLog(@"Error :%@",error.localizedDescription);
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [wSelf.tableView_iPhone reloadData];
                    });
                }
            }];
        }else if (self.tableViewSong_iPhone == TableViewSong_iPhoneSong){
            self.fetchResultSongs = nil;
            [self.tableView_iPhone reloadData];
            [sqliteExport excuteBlockInBackground:^{
                
                NSString *searchKey = textField.text;
                if (searchKey.length == 0) {
                    [wSelf fetchResultsSongs];
                }else{
                    [wSelf fetchResultsSongsWithRequest:[wSelf fetchRequestSongWithKey:searchKey]];
                }
            }];
        }else if(self.tableViewSong_iPhone == TableViewSong_iPhoneType) {
            self.fetchResultSongs = nil;
            [self.tableView_iPhone reloadData];
            [sqliteExport excuteBlockInBackground:^{
                NSString *searchKey = textField.text;
                if (searchKey.length == 0) {
                    [wSelf didTouchedSongType:nil];
                }else{
                    [wSelf fetchResultsSongTypeWithFetchRequest_iPad:[self fetchRequestSongTypeWithKey_iPad:searchKey]];
                }
            }];
        }
        NSLog(@"OK");
    }
    if (textField.text.length == 0) {
        return YES;
    }
    [self.view makeToast:@"Đang tìm kiếm"];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    __weak typeof(self)wSelf = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.view makeToast:@"Đang tìm kiếm"];

        if (textField == self.txtSearchSingerName) {
            self.fetchResultSingers = nil;
            [self.collectionView_iPad reloadData];
            if (self.collectionViewCellType == CollectionViewCellSinger_iPadTypeSinger) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [sqliteExport excuteBlockInBackground:^{
                        
                        NSString *searchKey = textField.text;
                        if (searchKey.length == 0) {
                            [wSelf fetchResultsSinger];
                        }else{
                            [wSelf fecthResultsSingerWithPredicate:[wSelf fetchRequestSingerWithKey:searchKey]];
                        }
                    }];
                });
            }else if (self.collectionViewCellType == CollectionViewCellSinger_iPadTypeSongType){
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [sqliteExport excuteBlockInBackground:^{
                        
                        NSString *searchKey = textField.text;
                        if (searchKey.length == 0) {
                            [wSelf fetchResultsSongType];
                        }else{
                            [wSelf fetchResultsSongTypeWithFetchRequest_iPad:[wSelf fetchRequestSongTypeWithKey_iPad:searchKey]];
                        }
                    }];
                });
            }

            
        }else{
            self.fetchResultSongs = nil;
            [self.tableView_iPad reloadData];
            [self.tableView_iPhone reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [sqliteExport excuteBlockInBackground:^{
                    NSString *searchKey = textField.text;
                    if (searchKey.length == 0) {
                        [wSelf fetchResultsSongs];
                    }else{
                        [wSelf fetchResultsSongsWithRequest:[wSelf fetchRequestSongWithKey:wSelf.txtSearchSongName.text]];
                    }
                }];
            });
            
        }
    }

    return YES;
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}
#pragma mark - ScanLANIP Delegate
-(void)scanLANIPDidConnectToANA:(ConnectTCP *)socket{
    self.viewScanIP.hidden = YES;
    self._connectTCP = socket;
}

-(void)scanLANIPDidFinishedScan:(ConnectTCP *)socket{
    if (!socket.roomBindingCode) {
        [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Can't find BOX" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil] show];
        self.viewScanIP.hidden = YES;
    }
}
-(void)scanLANIPFailed{
//    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Can't connect to network" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil] show];
}
-(void)clearScanToolIP{
    self._scanLanIPTool = nil;
}

-(void)startScanToolIP{
    self._scanLanIPTool = [[ScanLANIP alloc]init];
    self._scanLanIPTool.delegate = self;
    self._connectTCP = self._scanLanIPTool._connectTCP;
    [self._scanLanIPTool startScanIPInLan];
}
#pragma mark - TapGesture
-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];

    for (TableViewCellSong_iPad *cell in self.tableView_iPad.visibleCells) {
        if (cell.viewContentButton.hidden == NO) {
            cell.viewContentButton.hidden = YES;
        }
    }
    
    for (TableViewCellSong_iPhone *cell in self.tableView_iPhone.visibleCells) {
        if (cell.viewContentButton.hidden == NO) {
            cell.viewContentButton.hidden = YES;
        }
    }
}

-(void)handleTapGestureTableViewIpad:(UITapGestureRecognizer*)gestureRecognizer{
    UIView *view = gestureRecognizer.view;
    if (view == self.tableView_iPhone) {
        for (TableViewCellSong_iPhone *cell in self.tableView_iPhone.visibleCells) {
            if (cell.viewContentButton.hidden == NO) {
                cell.viewContentButton.hidden = YES;
            }
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView_iPhone];
            NSIndexPath *indexPath = [self.tableView_iPhone indexPathForRowAtPoint:swipeLocation];
            switch (self.tableViewSong_iPhone) {
                case TableViewSong_iPhoneSinger:
                {
                    self.btnBaiHat_iPhone.selected = YES;
                    self.btnCasi_iPhone.selected = NO;
                    self.btnDaChon_iPhone.selected = NO;
                    self.btnTheLoai_iPhone.selected = NO;
                    
                    self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
                    Singer *singer = [self.fetchResultSongs objectAtIndexPath:indexPath];
                    [self fetchResultSongWithSingerName:singer.name];
                    
                }
                    break;
                case TableViewSong_iPhoneType:{
                    self.btnBaiHat_iPhone.selected = YES;
                    self.btnCasi_iPhone.selected = NO;
                    self.btnDaChon_iPhone.selected = NO;
                    self.btnTheLoai_iPhone.selected = NO;
                    self.tableViewSong_iPhone = TableViewSong_iPhoneSong;
                    SongType *songType = [self.fetchResultSongs objectAtIndexPath:indexPath];
                    [self fetchResultSongWithTypeName:songType.tableName];
                }
                    break;
                case TableViewSong_iPhoneSong:{
                    self.btnBaiHat_iPhone.selected = YES;
                    self.btnCasi_iPhone.selected = NO;
                    self.btnDaChon_iPhone.selected = NO;
                    self.btnTheLoai_iPhone.selected = NO;
                    TableViewCellSong_iPhone* cell = (TableViewCellSong_iPhone*)[self.tableView_iPhone cellForRowAtIndexPath:indexPath];
                    cell.viewContentButton.hidden = NO;
                }
                    break;
                default:
                    break;
            }
           
        }
    }else{
        for (TableViewCellSong_iPad *cell in self.tableView_iPad.visibleCells) {
            if (cell.viewContentButton.hidden == NO) {
                cell.viewContentButton.hidden = YES;
            }
        }
        if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
            CGPoint swipeLocation = [gestureRecognizer locationInView:self.tableView_iPad];
            NSIndexPath *swipedIndexPath = [self.tableView_iPad indexPathForRowAtPoint:swipeLocation];
            TableViewCellSong_iPad* cell = (TableViewCellSong_iPad*)[self.tableView_iPad cellForRowAtIndexPath:swipedIndexPath];
            cell.viewContentButton.hidden = NO;
        }
    }

}
#pragma mark - Init life vehicle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.btnBaiHat_iPhone.selected = YES;

    
    [self.tableView_iPad addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureTableViewIpad:)]];
    
    [self.tableView_iPhone addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGestureTableViewIpad:)]];
    self.activityIp.hidesWhenStopped = YES;
    [self.activityIp startAnimating];
    [self startScanToolIP];
    
    self.collectionViewCellType = CollectionViewCellSinger_iPadTypeSinger;
    sqliteExport = [[SQLiteExport alloc]init];
    
    self.txtSearchSingerName.delegate = self;
    self.txtSearchSongName.delegate = self;
    self.txtSearch_iPhone.delegate = self;
    
    self.txtSearchSongName.returnKeyType = UIReturnKeyDone;
    self.txtSearchSingerName.returnKeyType = UIReturnKeyDone;
    if (!semaphore) {
 //       semaphore = dispatch_semaphore_create(0);
    }
    __weak typeof(self) wSelf = self;
    [self configTableView];
    [self configCollectionView];
    [self configIndicatorView];

    [sqliteExport exportSQLiteToLog:^{
        [wSelf fetchResultsSinger];
//        dispatch_semaphore_signal(semaphore);
    }];

    [sqliteExport exportSongTypeSQLiteToLog:^{
        
    }];
    
    [sqliteExport exportSongGouYuSQLToLog:^{
        
    }];
    
    [sqliteExport exportSongSQLiteToLog:^{
        [wSelf fetchResultsSongs];
    }];
  //  [self getPhysicalMemoryValue];
 //   dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
  //  MorinitoringMemory *morinitor = [[MorinitoringMemory alloc]init];
  //  [morinitor startMornitoringRAMWithTimer:10];
    
    [ConnectionNetwork shareInstance];
    NotifReg(self, @selector(handleConnectionNetwork:), kHandleConnectionNetwork);
    
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
        if (self.fetchResultSongs.sections.count == 0) {
            cell.hidden = YES;
            return cell;
        }
        
        Song *song = [self.fetchResultSongs objectAtIndexPath:indexPath];
        cell.song = song;
        cell.lbName.text = [song.songName uppercaseString];
        cell.lbSingerName.text = song.singerName;
        cell.lbCode.text = [NSString stringWithFormat:@"%@",song.idSong];
        if (indexPath.row % 2== 1) {
            cell.backgroundCell.alpha = 0.6;
        }else{
            cell.backgroundCell.alpha = 0.9;
        }
        cell.viewContentButton.hidden = YES;
        return cell;
    }else{
        TableViewCellSong_iPhone *cell = [self.tableView_iPhone dequeueReusableCellWithIdentifier:@"TableViewCellSong_iPhone" forIndexPath:indexPath];
        cell.lbCode.text = @"";
        cell.lbSingerName.text = @"";
        if (self.fetchResultSongs.sections.count == 0) {
            cell.hidden = YES;
            return cell;
        }
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
                cell.lbCode.text = song.idSong;
                cell.song = song;
                
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
        cell.viewContentButton.hidden = YES;
        return cell;
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
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
                break;
            case TableViewSong_iPhoneSong:{
                Song *song = [self.fetchResultSongs objectAtIndexPath:indexPath];
                XMLPackets *packet = [[XMLPackets alloc]init];
                ConnectTCP *connectTCP = [ConnectTCP shareInstance];
                NSString *xmlString =  [[packet selectSongWithIP:connectTCP.hostIP roomBindingCode:connectTCP.roomBindingCode withId:song.idSong] compactXMLString];
                [connectTCP writeData:xmlString];
            }
                break;
            default:
                break;
        }
    }else{
       
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
            if (self.fetchResultSingers.sections.count == 0) {
                singerCell.hidden = YES;
                return singerCell;
            }
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

#pragma mark - NOtification
-(void)handleConnectionNetwork:(NSNotification*)notifi{
    ConnectionNetworkStatus status = [notifi.object intValue];
    switch (status) {
        case ConnectionNetworkStatusNotReachable:{
            [self handleConnectionNetworkWasLost];
        }
            break;
        case ConnectionNetworkStatusReachableViaWiFi:{
            [self handleConnectionNetworkWasWoriking];
            [self handleConnectionNetworkWasWorikingWithWifi];
        }
            break;
        case ConnectionNetworkStatusReachableViaWWAN:{
            [self handleConnectionNetworkWasWoriking];
            [self handleConnectionNetworkWasWorikingWithWWan];
        }
            break;
        default:
            break;
    }
}
-(void)handleConnectionNetworkWasWoriking{
    self._scanLanIPTool._connectTCP.isConnected = YES;
}
-(void)handleConnectionNetworkWasLost{
    self._scanLanIPTool._connectTCP.isConnected = NO;
    [self._scanLanIPTool stopScanIPInLan];
    [[[UIAlertView alloc]initWithTitle:@"ERROR" message:@"Can't connect to network" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Close", nil] show];
    self.viewScanIP.hidden = YES;
}
-(void)handleConnectionNetworkWasWorikingWithWifi{
    
}
-(void)handleConnectionNetworkWasWorikingWithWWan{
    
}

-(BOOL)isHasNetwork{
    return [[ConnectionNetwork shareInstance] networkStatus] != ConnectionNetworkStatusNotReachable;
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    [self didTouchedDrumButton:nil];
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
