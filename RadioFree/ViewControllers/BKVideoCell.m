//
//  BKVideoCell.m
//  RadioFree
//
//  Created by vivek on 27/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "BKVideoCell.h"

@implementation BKVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.VideoView setBackgroundColor:[UIColor blackColor]];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, __WIDTH__(self.VideoView), __HEIGHT__(self.VideoView))];
    [imageview setImage:[UIImage imageNamed:@"YouTubePlaceHolder"]];
    [self.VideoView addSubview:imageview];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)prepareForReuse{
    [super prepareForReuse];
//    if (self.VideoView) {
//        [self.VideoView removeWebView];
//    }
}
@end
