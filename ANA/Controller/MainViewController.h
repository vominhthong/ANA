//
//  MainViewController.h
//  ANA
//
//  Created by Minh Thong on 8/20/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+ASII.h"
@interface MainViewController : UIViewController
@property (nonatomic,weak) IBOutlet UICollectionView *collectionView_iPad;
@property (nonatomic,weak) IBOutlet UITableView *tableView_iPad;
@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *indicatorViewTableView_iPad;
@property (nonatomic,weak) IBOutlet UITextField *txtSearchSingerName;
@property (nonatomic,weak) IBOutlet UITextField *txtSearchSongName;

@property (nonatomic,weak) IBOutlet UITableView *tableView_iPhone;

@property (nonatomic,weak) IBOutlet UIActivityIndicatorView *activityIp;
@property (nonatomic,weak) IBOutlet UIView *viewScanIP;
@end

