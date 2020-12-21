//
//  UtilFunctions.m
//  RadioFree
//
//  Created by vivek on 06/01/18.
//  Copyright © 2018 Aimperior. All rights reserved.
//

#import "UtilFunctions.h"

extern BOOL isEqualImages(UIImage *image1, UIImage *image2){
    NSData *imageData1 = UIImagePNGRepresentation(image1);
    NSData *imageData2 = UIImagePNGRepresentation(image2);
    BOOL isEqual = imageData1 == imageData2 ? YES : NO;
    return isEqual;
}

extern NSInteger AssignPage(BOOL pageReload){
    if (pageReload) {
        APPDELEGATE.PostPageNumber = 1;
        return APPDELEGATE.PostPageNumber;
    }else{
        APPDELEGATE.PostPageNumber = APPDELEGATE.PostPageNumber>0?APPDELEGATE.PostPageNumber:1;
        return APPDELEGATE.PostPageNumber;
    }
}

extern UILabel* setLableSize(UILabel *lable, UIFont *font){
    
    CGRect textRect = [lable.text boundingRectWithSize:CGSizeMake(lable.frame.size.width, 9999)
        options:NSStringDrawingUsesLineFragmentOrigin
        attributes:@{NSFontAttributeName:font}
                                                 context:nil];
    CGSize possibleSize = textRect.size;
    CGRect newFrame = lable.frame;
    newFrame.size.height = possibleSize.height;
    lable.frame = newFrame;
    return lable;
}

@implementation UtilFunctions
+(NSString *)convertHTML:(NSString *)html {
    
    NSScanner *myScanner;
    NSString *text = nil;
    myScanner = [NSScanner scannerWithString:html];
    
    while ([myScanner isAtEnd] == NO) {
        
        [myScanner scanUpToString:@"<" intoString:NULL] ;
        
        [myScanner scanUpToString:@">" intoString:&text] ;
        
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>", text] withString:@""];
    }
    //
    html = [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return html;
}

+(NSString *)ConvertHTMLStringAttributeToPlainString:(NSString*)string{
    NSAttributedString *stringa = [[NSAttributedString alloc] initWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}
                                                        documentAttributes:nil error:nil];
    NSString *plainText = [stringa string];
    return plainText;
}
+(NSString *)getDateFromStringDate:(NSString *)strDate{
    
    NSArray *dateArray1 = [strDate componentsSeparatedByString:@"T"];
    
    NSArray *dateArray2 = [dateArray1[0] componentsSeparatedByString:@"-"];
    return [NSString stringWithFormat:@"%@/%@/%@",dateArray2[1],dateArray2[2],dateArray2[0]];
}
@end
