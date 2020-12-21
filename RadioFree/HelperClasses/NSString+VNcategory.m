//
//  NSString+VNcategory.m
//  customViewDemo11
//
//  Created by vivek on 29/12/17.
//  Copyright © 2017 Aimperior. All rights reserved.
//

#import "NSString+VNcategory.h"

@implementation NSString (VNcategory)

- (NSString *)stringByStrippingHTML:(NSString *)inputString
{
    NSMutableString *outString;
    
    if (inputString)
    {
        outString = [[NSMutableString alloc] initWithString:inputString];
        
        if ([inputString length] > 0)
        {
            NSRange r;
            
            while ((r = [outString rangeOfString:@"<[^>]+>|&nbsp;" options:NSRegularExpressionSearch]).location != NSNotFound)
            {
                [outString deleteCharactersInRange:r];
            }
        }
    }
    
    return outString; 
}

//-(NSString *) stringByStrippingHTML {
//    
////    NSRange r;
////    NSString *s = [self copy];
////    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
////        s = [s stringByReplacingCharactersInRange:r withString:@""];
////    return s;
//}
@end
