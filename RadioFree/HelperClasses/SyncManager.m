//
//  SyncManager.m
//  Ebizident
//
//  Created by Pritesh Pethani on 10/12/15.
//  Copyright © 2015 Pritesh Pethani. All rights reserved.
//

#import "SyncManager.h"

@implementation SyncManager

-(void) webServiceCall:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag{
    
    NSURL *baseURL = [NSURL URLWithString:url];
    
    
   
    
    
    
    
//        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
//
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
//        manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//        [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
//
//    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
//
//    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [self.delegate syncSuccess:responseObject withTag:tag];
//                StatusBarActivityIndicatorHide;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [self.delegate syncFailure:error withTag:tag];
//    }];
    
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    
    [manager.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.delegate syncSuccess:responseObject withTag:tag];
        StatusBarActivityIndicatorHide;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.delegate syncFailure:error withTag:tag];
    }];

    
//    [manager GET:url parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self.delegate syncSuccess:responseObject withTag:tag];
//        StatusBarActivityIndicatorHide;
//        //[SVProgressHUD dismiss];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self.delegate syncFailure:error withTag:tag];
//    }];
    
   // [manager POST:url parameters:params success:^(NSURLSessionDataTask *task, id
     //                                       responseObject) {
       // [self.delegate syncSuccess:responseObject withTag:tag];
     //   [SVProgressHUD dismiss];

        
  //  } failure:^(NSURLSessionDataTask *task, NSError *error) {
      //  [self.delegate syncFailure:error withTag:tag];
        
   // }];
}
@end
