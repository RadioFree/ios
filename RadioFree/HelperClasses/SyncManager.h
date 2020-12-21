//
//  SyncManager.h
//  Ebizident
//
//  Created by Pritesh Pethani on 10/12/15.
//  Copyright © 2015 Pritesh Pethani. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Header.h"
/** AFNetworking Delegate નો ઉપયોગ server પરથી ડેટા લાવવા માટે કરેલો છે.
    આ Delegate બનાવા માટે AFNetworking Framework નો ઉપયોગ કરેલો છે.
 */
@protocol SyncManagerDelegate <NSObject>
@required
/** Delegate ની આ Method Server પરથી Tag નો ઉપયોગ કરીને Result આપશે.
 @param responseObject - જો Sucessfullly server પરથી Result મળી જશે તો આ Object માં result આવશે.
 @param tag - આ Object માં આપણે Opration ની Tag આવશે.
 */
-(void)syncSuccess:(id) responseObject withTag:(NSInteger)tag;
/** જો server પર આપણે જે result માટેની request કરેલી હશે તે fail થશે to આ method કોલ થશે.
 @param error - આ Object માં આપણે Result fail થવા પાછળ નું કારણ આપશે.
 @param tag - આ Object માં આપણે Opration ની Tag આવશે.
 */
-(void)syncFailure:(NSError*) error withTag:(NSInteger)tag;

@end

@interface SyncManager : NSObject
{
    /** આ Delegate નો Object છે.*/
    id <SyncManagerDelegate> _delegate;
    
}
/** અહીંયા Delegate Object ને Property બનાવામાં આવે છે. જેથી કરીને આપણે Application માં કોઈ પણ Class માંથી આપણે આ Delegate નો ઉપયોગ કરી સકાશે.*/
@property (nonatomic,strong) id delegate;

/** આ Method દ્વારા Server ને Request કરવામાં આવે છે.
 @param url - આ Object માં Request url પાસ કરવાની છે.
 @param params - આ Object માં User એ Request માટે ના Parameter પાસ કરવાના છે.
 @param tag - આ Object માં આપણે Opration ની Tag પાસ કરવાની છે.
 */
-(void) webServiceCall:(NSString*)url withParams:(NSDictionary*) params withTag:(NSInteger) tag;
@end
