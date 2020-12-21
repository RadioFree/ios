//
//  BKDetailViewController.h
//  RadioFree
//
//  Created by vivek on 29/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface BKDetailViewController : UIViewController
@property (nonatomic, strong) NSString *stringPostId;
@property (nonatomic, strong) NSString *stringPostFormat;
@property (nonatomic, strong) NSTimer *timer;
-(void)detailViewNewsPostId:(NSString *)postId postFormat:(NSString *)format;
@end
