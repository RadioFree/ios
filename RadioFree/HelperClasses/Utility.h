//
//  Utility.h
//  Feeder
//
//  Created by Pritesh Pethani on 12/9/15.
//  Copyright (c) 2015 Pritesh Pethani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Header.h"

@interface Utility : NSObject

#pragma mark - Check Internet Available
+(BOOL)CheckForInternet;

#pragma mark String is empty or not
+(BOOL)isEmpty:(NSString *)str;

#pragma mark Setting Radio Button Images
+(void)setMultipleRadioBtnImage:(UIImageView *)firstRadioBtnImage secondRadioBtnImage:(UIImageView *)secondRadioBtnImage thirdRadioBtnImage:(UIImageView *)thirdRadioBtnImage;

#pragma mark email validation
+(BOOL)validateEmail:(NSString*)email;

#pragma mark PhoneNumber validation
+(BOOL)validatePhone:(NSString *)phoneNumber;


#pragma mark - Date Format Methods
+(NSString *)getStringFromDate:(NSDate *)dateval format:(NSString *)Strformat;
+(NSString *)getDateFromString:(NSString *)mySstring;

#pragma mark - compare images
+(BOOL)CompareImg:(UIImage *)firstImg secondImg:(UIImage *)secondImg;

#pragma mark - Resize image
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (UIImage *)SizeForImage:(UIImage *)image width:(float)fixedWidth;
@end
