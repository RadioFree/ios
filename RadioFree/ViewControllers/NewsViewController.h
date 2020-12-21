//
//  NewsViewController.h
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
static const NSInteger SpaceBetweenAudioViewAndTitleLable = 20;
static const NSInteger CellYSpace = 16;
static const NSInteger DateViewHeight = 26;
static const NSInteger SpaceBetweenDateViewAndDescriptionLable = 15;
static const NSInteger CellBottomSpace = 5;
static const NSInteger SpaceBetweenDateViewAndTitleLable = 1;
static const NSInteger YouTubeVideoViewHeight = 180;
static const NSInteger SpaceBetweenAudioViewAndDescriptionLable = 10;
static const NSInteger AudioViewHeight = 65;
static const NSInteger SpaceBetweenAuthorNameAndDescription = 0;

@interface NewsViewController : UIViewController
//-(void)getButtonIndex:(NSInteger)tag;
@property (nonatomic, strong) NSTimer *timer;
@end
