//
//  NetworkManager.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "NetworkConstants.h"
/**
 *  Main network operations class - handles all API calls
 */
@interface NetworkManager : NSObject

/**
 *  Session manager used to call MDM API
 */
@property(strong,readonly)AFHTTPSessionManager* mdmSessionManager;

/**
 *  Session manager used to call SafeKiddo API with JSON response
 */
@property(strong,readonly)AFHTTPSessionManager* apiJSONSessionManager;

/**
 *  Session manager used to call SafeKiddo API v2 with JSON response
 */
@property(strong,readonly)AFHTTPSessionManager* apiJSONSessionManagerv2;

/**
 *  Session manager used to call SafeKiddo API with NSString response
 */
@property(strong,readonly)AFHTTPSessionManager* apiNSStringSessionManager;

/**
 *  Singleton accessor methof
 *
 *  @return An instance of a manager
 */
+(NetworkManager *)sharedManager;

@end
