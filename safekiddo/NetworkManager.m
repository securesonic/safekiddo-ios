//
//  NetworkManager.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "SafeURLProtocol.h"



static NetworkManager* _instance;

@interface NetworkManager()

@end

@implementation NetworkManager

+(NetworkManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NetworkManager new];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _mdmSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kMDMBaseURLPath]];
        _apiJSONSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURLPath]];
        _apiJSONSessionManagerv2 = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURLPathV2]];
        _apiNSStringSessionManager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:kBaseURLPath]];

        AFHTTPRequestSerializer* requestSerializer = [AFHTTPRequestSerializer serializer];
        [requestSerializer setValue:[NSString stringWithFormat:kUserAgent,
                                     [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                                     [[UIDevice currentDevice]systemVersion]] forHTTPHeaderField:@"User-Agent"];

#ifdef DEV
        [requestSerializer setValue:@"1234" forHTTPHeaderField:@"X-SK-API-KEY"];
        [requestSerializer setValue:@"secret" forHTTPHeaderField:@"X-SK-API-SECRET"];
#endif
        
        [SafeURLProtocol makeRequestSerializer:requestSerializer requestsIgnoreSafeProtocol:YES];
        
        [_mdmSessionManager setRequestSerializer:requestSerializer];
        [_apiJSONSessionManager setRequestSerializer:requestSerializer];
        [_apiJSONSessionManagerv2 setRequestSerializer:requestSerializer];

        
        
        [_apiNSStringSessionManager setRequestSerializer:requestSerializer];
        
        [_mdmSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [_apiNSStringSessionManager setResponseSerializer:[AFHTTPResponseSerializer serializer]];
        [_apiJSONSessionManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
        [_apiJSONSessionManagerv2 setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}



@end
