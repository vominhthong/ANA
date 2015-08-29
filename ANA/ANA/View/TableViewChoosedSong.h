//
//  TableViewChoosedSong.h
//  ANA
//
//  Created by Minh Thong on 8/29/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewChoosedSong : UITableView <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSMutableArray *arrChoosedSong;
@end
