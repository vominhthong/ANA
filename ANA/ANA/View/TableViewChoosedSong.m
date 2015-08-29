//
//  TableViewChoosedSong.m
//  ANA
//
//  Created by Minh Thong on 8/29/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "TableViewChoosedSong.h"
#import "DDXML.h"
#import "TableViewChoosedSong_Cell.h"
@implementation TableViewChoosedSong
-(NSMutableArray *)arrChoosedSong{
    if (!_arrChoosedSong) {
        _arrChoosedSong = [NSMutableArray array];
    }
    return _arrChoosedSong;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrChoosedSong.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TableViewChoosedSong_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewChoosedSong_Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    NSXMLElement *element = [self.arrChoosedSong objectAtIndex:indexPath.row];
    cell.lbName.text = [[element attributeForName:@"songname"] stringValue];
    cell.lbCode.text = [[element attributeForName:@"songid"] stringValue];
    if (indexPath.row % 2== 1) {
        cell.backgroundCell.alpha = 0.6;
    }else{
        cell.backgroundCell.alpha = 0.9;
    }
    return cell;
}
@end
