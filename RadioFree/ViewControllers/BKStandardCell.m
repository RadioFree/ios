//
//  BKStandardCell.m
//  RadioFree
//
//  Created by vivek on 27/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "BKStandardCell.h"

@implementation BKStandardCell
@synthesize TitleLable=_TitleLable,
descriptionLable = _descriptionLable,
dateView = _dateView,
dateLable = _dateLable;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
