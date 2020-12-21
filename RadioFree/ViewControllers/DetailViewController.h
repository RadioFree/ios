//
//  DetailViewController.h
//  RadioFree
//
//  Created by vivek on 13/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"

static const NSInteger SpaceBetweenTitleAndDate = 6;
static const NSInteger BottomSpaceInHedderContentView = 20;
static const NSInteger SpaceBetweenTwoContentView = 10;

@interface DetailViewController : UIViewController
@property (nonatomic, strong) NSString *stringPostId;
@property (nonatomic, strong) NSString *stringPostFormat;
@property (nonatomic, strong) NSTimer *timer;
-(void)detailViewNewsPostId:(NSString *)postId postFormat:(NSString *)format;
@end
