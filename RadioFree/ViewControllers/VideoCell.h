//
//  VideoCell.h
//  RadioFree
//
//  Created by vivek on 10/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"
@interface VideoCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet YTPlayerView *VideoView;
@property (strong, nonatomic) IBOutlet UILabel *AuthorName;





@end
