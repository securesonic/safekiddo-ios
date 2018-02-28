//
//  NetworkManager+Authentication.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "LoginResponse.h"
#import "Response.h"

@interface NetworkManager (Authentication)

/**
 *  Authenticates a user.
 *
 *  @param login        Users login defined when creating account
 *  @param password     Users password defined when creating account
 *  @param successBlock Block called on succesfull login
 *  @param failureBlock Block called on a failed login
 *
 *  @return Session data task
 */
+(NSURLSessionTask*)loginWithLogin:(NSString*)login
                          password:(NSString*)password
                      successBlock:(void(^)(LoginResponse*))successBlock
                      failureBlock:(void(^)(NSError*))failureBlock;


/**
 *  Logs out a used
 *
 *  @param successBlock Block called on succesfull logout
 *  @param failureBlock Block called on faied logout
 *
 *  @return Session data task
 */
+(NSURLSessionTask*)logoutWithSuccessBlock:(void(^)(Response*))successBlock
                              failureBlock:(void(^)(NSError*))failureBlock;

@end
