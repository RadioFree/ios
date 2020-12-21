//
//  StandardCell.h
//  RadioFree
//
//  Created by vivek on 10/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StandardCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *descriptionLable;
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
@property (strong, nonatomic) IBOutlet UILabel *TitleLable;
@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UILabel *AuthorName;
@property (strong, nonatomic) IBOutlet UIImageView *FeatureImage;

@end
