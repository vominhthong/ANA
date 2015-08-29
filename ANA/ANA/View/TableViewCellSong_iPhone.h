//
//  TableViewCellSong_iPhone.h
//  ANA
//
//  Created by Minh Thong on 8/25/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
@interface TableViewCellSong_iPhone : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *lbName;
@property (nonatomic,weak) IBOutlet UIImageView *backgroundCell;
@property (nonatomic,weak) IBOutlet UILabel *lbSingerName;
@property (nonatomic,weak) IBOutlet UILabel *lbCode;
@property (nonatomic,strong) Song* song;
@property (nonatomic,weak) IBOutlet UIView *viewContentButton;
@end
