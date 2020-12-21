//
//  Utility.m
//  Feeder
//
//  Created by Pritesh Pethani on 12/9/15.
//  Copyright (c) 2015 Pritesh Pethani. All rights reserved.
//

#import "Utility.h"

@implementation Utility


#pragma mark - Check Internet Available
+(BOOL)CheckForInternet
{
    //Test for Internet Connection
    NSString *hostName = @"www.google.com";
    Reachability *r = [Reachability reachabilityWithHostName:hostName];
    
    NetworkStatus internetStatus = [r currentReachabilityStatus];
    
    BOOL internet;
    
    if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
    {
        internet = NO;
    }
    else
    {
        internet = YES;
    }
    return internet;
}

#pragma mark String is empty or not

+(BOOL)isEmpty:(NSString *)str
{
    if(str.length==0 || [str isKindOfClass:[NSNull class]] || [str isEqualToString:@""] ||[str  isEqualToString:NULL] || [str isEqualToString:@"(null)"] || str==nil || [str isEqualToString:@"<null>"]  || [str isEqualToString:@"null"])
    {
        return YES;
    }
    return NO;
}

#pragma mark Setting Radio Button Images

+(void)setMultipleRadioBtnImage:(UIImageView *)firstRadioBtnImage secondRadioBtnImage:(UIImageView *)secondRadioBtnImage thirdRadioBtnImage:(UIImageView *)thirdRadioBtnImage
{
    firstRadioBtnImage.image = [UIImage imageNamed: @"halfFill.png"];
    secondRadioBtnImage.image = [UIImage imageNamed: @"fill.png"];
    thirdRadioBtnImage.image = [UIImage imageNamed: @"fill.png"];
}

#pragma mark email validation

+(BOOL)validateEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL isValid = [emailTest evaluateWithObject:email];
    return isValid;
}

#pragma mark PhoneNumber validation

+(BOOL)validatePhone:(NSString *)phoneNumber
{
    NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:phoneNumber];
}


#pragma mark - Date Format Methods

+(NSString *)getStringFromDate:(NSDate *)dateval format:(NSString *)Strformat
{
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:Strformat];
    NSString *dateString=[dateFormater stringFromDate:dateval];
    return dateString ;
}

+(NSString *)getDateFromString:(NSString *)mySstring
{
    //NSString *dateString = [NSString stringWithFormat: @"%@",mySstring];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate* myDate = [dateFormatter dateFromString:mySstring];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy  a hh:mm "];
    NSString *stringFromDate = [formatter stringFromDate:[dateFormatter dateFromString:mySstring]];
    NSLog(@"%@", stringFromDate);
    return stringFromDate;
}

#pragma mark - compare images

+(BOOL)CompareImg:(UIImage *)firstImg secondImg:(UIImage *)secondImg
{
    NSData *imgData1 = UIImagePNGRepresentation(firstImg);
    NSData *imgData2 = UIImagePNGRepresentation(secondImg);
    
    BOOL isCompare = [imgData1 isEqual:imgData2];
    return isCompare;
    
    //---for button
    //    UIImage *img = [btnPencil imageForState:UIControlStateNormal];
}

+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

//+ (UIImage *)SizeForImage:(UIImage *)image
//{
//    CGSize newsize = image.size;
//    if (newsize.width > 320)
//    {
//        newsize.height /= (newsize.width / 320);
//        newsize.width = 320;
//    }
//    
//    
//    UIGraphicsBeginImageContext( newsize );
//    [image drawInRect:CGRectMake(0,0,newsize.width,newsize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return newImage;
//}

+ (UIImage *)SizeForImage:(UIImage *)image width:(float)fixedWidth
{
    CGSize newsize = image.size;
    if (newsize.width > fixedWidth)
    {
        newsize.height /= (newsize.width / fixedWidth);
        newsize.width = fixedWidth;
    }
    
    UIGraphicsBeginImageContext( newsize );
    [image drawInRect:CGRectMake(0,0,newsize.width,newsize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
