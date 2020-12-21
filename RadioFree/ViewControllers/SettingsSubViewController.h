//
//  SettingsSubViewController.h
//  RadioFree
//
//  Created by vivek on 16/02/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface SettingsSubViewController : UIViewController
@property (nonatomic, strong) NSString *SettingsPostTypeValueString;
@property(nonatomic, strong) NSString *SettingsPostTypeZeroUrlString;
-(void)getPostTypeValueForSettings:(NSString *)value;
-(void)getPostTypeValueForZeroUrl:(NSString *)Url;
-(void)getSettingsKey:(NSInteger)key;
@end
