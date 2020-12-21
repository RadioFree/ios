//
//  VideoCell.m
//  RadioFree
//
//  Created by vivek on 10/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "VideoCell.h"
#import "Header.h"
@implementation VideoCell
@synthesize titleLable = _titleLable,
            dateView = _dateView,
            dateLable = _dateLable;


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
