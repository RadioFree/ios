//
//  LiveViewController.h
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"
#import "Header.h"

@interface LiveViewController : UIViewController
//@property (readwrite, retain) STKAudioPlayer* audioPlayer;
//-(void)loadAudioPlayer:(STKAudioPlayer *)audioPlayerIn;
-(void)didNotifyToPlayButton;
@end
