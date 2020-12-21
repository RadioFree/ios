//
//  Macros.h
//  RadioFree
//
//  Created by vivek on 14/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//
#import <UIKit/UIKit.h>
#ifndef Macros_h
#define Macros_h

// Create AppDelegate Objects
#define APPDELEGATE ((AppDelegate*)[[UIApplication sharedApplication] delegate])

// set Height,Width,X,Y
#pragma mark -  CGRECT
#define __HEIGHT__(O) O.frame.size.height
#define __WIDTH__(O)  O.frame.size.width
#define __X__(O)      O.frame.origin.x
#define __Y__(O)      O.frame.origin.y
#define GET_FRAME(O) CGRectMake(__X__(O), __Y__(O), __WIDTH__(O), __HEIGHT__(O))

// set Border Color and width

#define SET_BORDER(O,C,W)\
O.layer.borderColor=[C CGColor];\
O.layer.borderWidth=W;

// set Corner Radios

#define SET_CORNER_RADIOS(O,W)  O.layer.cornerRadius = W ;\
O.clipsToBounds=YES;

// show Alert
#define showAlert(messageT,title) UIAlertView *alert=[[UIAlertView alloc] initWithTitle:messageT message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];[alert show];

// StatusBar Activity Indicatior
#define StatusBarActivityIndicatorShow [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

#define StatusBarActivityIndicatorHide [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

//UI Color Macro---------------------
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)

// Device Settings
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define device UI_USER_INTERFACE_IDIOM()
#define iphone UIUserInterfaceIdiomPhone
#endif /* Macros_h */
