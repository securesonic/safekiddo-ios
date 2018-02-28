//
//  SafeURLProtocol.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFURLRequestSerialization.h>
#import "RequestTracker.h"

FOUNDATION_EXPORT BOOL safeURLProtocolDebugMode;
FOUNDATION_EXPORT NSString* const kIgnoreSafeURLProtocolHTTPHeader;

@interface SafeURLProtocol : NSURLProtocol

+(BOOL)makeRequest:(NSMutableURLRequest*)request userAction:(BOOL)isUserAction withRequestTracker:(RequestTracker*)tracker;

+(void)makeRequestSerializer:(AFHTTPRequestSerializer*)serializer requestsIgnoreSafeProtocol:(BOOL)ignoreProtocol;

@end
