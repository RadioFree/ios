//
//  MenuContentViewController.h
//  RadioFree
//
//  Created by vivek on 20/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Header.h"
@interface MenuContentViewController : UIViewController
@property (nonatomic, strong) NSString *NavigationMenuPostTypeValueString;
@property (nonatomic, strong) NSString *NavigationMenuPostTypeZeroValueURLString;
-(void)getPostTypeValueForSettings:(NSString *)value;
-(void)getPostTypeValueURL:(NSString *)url;
//@property (nonatomic, assign) NSInteger MenuKey;
//-(void)menuItemKey:(NSInteger)tag;
@end
