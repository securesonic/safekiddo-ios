//
//  NetworkManager+Hearbeat.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager+Hearbeat.h"

@implementation NetworkManager (Hearbeat)

+(NSURLSessionTask*)heartbeatWithDeviceUUID:(NSString*)uuid successBlock:(void(^)(HeartbeatResponse*))successBlock failureBlock:(void(^)(NSError*))failureBlock
{
    
    return [[[self sharedManager] apiJSONSessionManagerv2] GET:[NSString stringWithFormat:kHeartBeatRequest,uuid]
                                                  parameters:nil
                                                     success:^(NSURLSessionDataTask *task, id responseObject)
            {
                NSError* error;
                HeartbeatResponse* response = [[HeartbeatResponse alloc]initWithDictionary:responseObject error:&error];
                
                if(error)
                {
                    if(failureBlock)
                    {
                        failureBlock(error);
                    }
                }else
                {
                    if(successBlock)
                    {
                        successBlock(response);
                    }
                }
            }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error)
            {
                if(failureBlock)
                {
                    failureBlock(error);
                }
            }];
}

@end
