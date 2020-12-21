//
//  AudioCell.m
//  RadioFree
//
//  Created by vivek on 10/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "AudioCell.h"
#import "Header.h"
@implementation AudioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForReuse{
    
//    if (self.playPauseButton.tag == APPDELEGATE.selectedIndexPath && APPDELEGATE.isPlayButton == YES) {
//        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//    }else{
//        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//    }
   
}
//- (IBAction)didActionToplayPauseButton:(UIButton*)sender {
//    
//    NSData *data1 = UIImagePNGRepresentation([UIImage imageNamed:@"play"]);
//    if ([data1 isEqual:UIImagePNGRepresentation(sender.currentImage)]) {
//      //  UITableView *tableview =(UITableView*)[self superview];
//       // [tableview setContentOffset:CGPointMake(tableview.frame.origin.x, tableview.frame.origin.y+3)];
//        NSURL* url = [NSURL URLWithString:self.AudioURLString];//
//        
//        STKDataSource* dataSource = [STKAudioPlayer dataSourceFromURL:url];
//        
//        [APPDELEGATE.audioPlayer setDataSource:dataSource withQueueItemId:[[SampleQueueId alloc] initWithUrl:url andCount:0]];
//        APPDELEGATE.selectedIndexPath = sender.tag;
//        APPDELEGATE.isPlayButton = YES;
//        [sender setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
//        
//    }else{
//        APPDELEGATE.isPlayButton = NO;
//        [sender setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
//        if (APPDELEGATE.audioPlayer.state == STKAudioPlayerStatePlaying)
//        {
//            [APPDELEGATE.audioPlayer pause];
//        }
//        StatusBarActivityIndicatorHide;
//    }

@end
