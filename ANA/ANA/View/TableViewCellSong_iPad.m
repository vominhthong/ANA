//
//  TableViewCellSong_iPad.m
//  ANA
//
//  Created by Minh Thong on 8/22/15.
//  Copyright (c) 2015 Minh Thong. All rights reserved.
//

#import "TableViewCellSong_iPad.h"
#import "XMLPackets.h"
#import "ConnectTCP.h"
#import "NSXMLElement+XMPP.h"
@implementation TableViewCellSong_iPad

- (IBAction)didTouchedChooseSong:(id)sender{
    XMLPackets *packet = [[XMLPackets alloc]init];
    ConnectTCP *connectTCP = [ConnectTCP shareInstance];
    NSString *xmlString =  [[packet selectSongWithIP:connectTCP.hostIP roomBindingCode:connectTCP.roomBindingCode withId:self.song.idSong] compactXMLString];
    [connectTCP writeData:xmlString];
    self.viewContentButton.hidden = YES;
}
- (IBAction)didTouchedPushSong:(id)sender {
    XMLPackets *packet = [[XMLPackets alloc]init];
    ConnectTCP *connectTCP = [ConnectTCP shareInstance];
    NSString *xmlString =  [[packet pushSongTopWithIP:connectTCP.hostIP roomBindingCode:connectTCP.roomBindingCode withId:self.song.idSong] compactXMLString];
    [connectTCP writeData:xmlString];
    self.viewContentButton.hidden = YES;

}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
//    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchedCellModal:)]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)didTouchedCellModal:(UITapGestureRecognizer*)tap{
    
}

@end
