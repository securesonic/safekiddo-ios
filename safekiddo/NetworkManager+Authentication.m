//
//  NetworkManager+Authentication.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager+Authentication.h"

@implementation NetworkManager (Authentication)

+(NSURLSessionTask*)loginWithLogin:(NSString*)login
                          password:(NSString*)password
                      successBlock:(void(^)(LoginResponse*))successBlock
                      failureBlock:(void(^)(NSError*))failureBlock
{
   return [[self sharedManager].apiJSONSessionManager POST:kLoginRequest
                                            parameters:@{kUsernameParam:login,kPasswordParam:password}
                                         success:^(NSURLSessionDataTask *task, id responseObject) {
                                             
                                             
                                             NSError* jsonError;
                                             LoginResponse* loginResponse = [[LoginResponse alloc]initWithDictionary:responseObject error:&jsonError];
                                             
                                             if(jsonError)
                                             {
                                                 if(failureBlock)
                                                 {
                                                     failureBlock(jsonError);
                                                 }
                                             }
                                             else
                                             {
                                                 if(successBlock)
                                                 {
                                                     successBlock(loginResponse);
                                                 }
                                             }
                                         }
                                         failure:^(NSURLSessionDataTask *task, NSError *error) {
                                             if(failureBlock)
                                             {
                                                 failureBlock(error);
                                             }
                                         }];
    
}

+(NSURLSessionTask*)logoutWithSuccessBlock:(void(^)(Response*))successBlock
                              failureBlock:(void(^)(NSError*))failureBlock
{
    return [[[self sharedManager] apiJSONSessionManager] POST:kLogoutRequest
                                               parameters:nil
                                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      NSError* jsonError;
                                                      Response* response = [[Response alloc]initWithDictionary:responseObject error:&jsonError];
                                                      
                                                      if(jsonError)
                                                      {
                                                          if(failureBlock)
                                                          {
                                                              failureBlock(jsonError);
                                                          }
                                                      }
                                                      else
                                                      {
                                                          if(successBlock)
                                                          {
                                                              successBlock(response);
                                                          }
                                                      }
                                                  } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      if(failureBlock)
                                                      {
                                                          failureBlock(error);
                                                      }
                                                  }];
}

@end
