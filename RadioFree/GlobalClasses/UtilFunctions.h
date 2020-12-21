//
//  UtilFunctions.h
//  RadioFree
//
//  Created by vivek on 06/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Header.h"

/** Compare two images and retun Boolean YES or NO
 @param image1 - Pass image1
 @param image2 - Pass Image2
 @return - retun BOOL yes or no
 */
extern BOOL isEqualImages(UIImage *image1, UIImage *image2);
/** Here Setting Post page number for Paging Functionality
 @param pageReload - here set bool to page is reload or not.
 @return - retun Page Number
 */
extern NSInteger AssignPage(BOOL pageReload);
/** this method is used to lable size fit to regarding content size.
 @param lable - here pass lable for sizeTofit.
 @param font - here pass font to used this lable.
 @return - retun lable to complete size.
 */
extern UILabel* setLableSize(UILabel *lable, UIFont *font);

@interface UtilFunctions : NSObject
+(NSString *)convertHTML:(NSString *)html;
+(NSString *)ConvertHTMLStringAttributeToPlainString:(NSString*)string;
+(NSString *)getDateFromStringDate:(NSString *)strDate;
@end
