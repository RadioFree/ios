//
//  BKAudioCell.h
//  RadioFree
//
//  Created by vivek on 27/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BKAudioCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLable;
@property (strong, nonatomic) IBOutlet UIView *audioView;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet UIButton *playPauseButton;
@property (strong, nonatomic) IBOutlet UILabel *progressLable;
@property (strong, nonatomic) IBOutlet UILabel *durationLable;
@property (strong, nonatomic) NSString *AudioURLString;
@property (strong, nonatomic) IBOutlet UILabel *AuthorName;

@end
