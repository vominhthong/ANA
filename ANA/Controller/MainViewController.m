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

@interface MainViewController () <UICollectionViewDataSource,UICollectionViewDelegate,NSFetchedResultsControllerDelegate,UITableViewDataSource,UITableViewDelegate>{
    dispatch_semaphore_t semaphore;
}
@property (nonatomic,strong) NSMutableArray *arrSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSingers;
@property (nonatomic,strong) NSFetchedResultsController *fetchResultSongs;
@end

@implementation MainViewController

#pragma mark - Initialize
-(NSMutableArray *)arrSingers{
    if (!_arrSingers) {
        _arrSingers = [[NSMutableArray alloc]init];
    }
    return _arrSingers;
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
}
-(void)configIndicatorView{
    self.indicatorViewTableView_iPad.hidesWhenStopped = YES;
    [self.indicatorViewTableView_iPad startAnimating];
}
#pragma mark - Fetch Result
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
        [wSelf.indicatorViewTableView_iPad stopAnimating];
    });
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

#pragma mark - Init life vehicle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SQLiteExport *sqliteExport = [[SQLiteExport alloc]init];
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
    
    [sqliteExport exportSongSQLiteToLog:^{
        [wSelf fetchResultsSongs];
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

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
    Singer *singer = [self.fetchResultSingers objectAtIndexPath:indexPath];
    singerCell.lbSingerName.text = singer.name;
    return singerCell;
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
