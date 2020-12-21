//
//  StandardCell.m
//  RadioFree
//
//  Created by vivek on 10/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "StandardCell.h"

@implementation StandardCell
@synthesize TitleLable=_TitleLable,
descriptionLable = _descriptionLable,
dateView = _dateView,
dateLable = _dateLable,
AuthorName = _AuthorName;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.TitleLable setNeedsLayout];
    [self.TitleLable layoutIfNeeded];
    [self.dateView setNeedsLayout];
    [self.dateView layoutIfNeeded];
    [self.FeatureImage setNeedsLayout];
    [self.FeatureImage layoutIfNeeded];
    [self.descriptionLable setNeedsLayout];
    [self.descriptionLable layoutIfNeeded];
    
}

@end
