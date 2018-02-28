//
//  NetworkManager+Children.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager+Children.h"

@implementation NetworkManager (Children)

+(NSURLSessionTask*)childsWithSuccessBlock:(void(^)(ChildsResponse*))successBlock
                              failureBlock:(void(^)(NSError*))failureBlock
{
    
    return [[[self sharedManager] apiJSONSessionManager] GET:kChildsRequest
                                             parameters:nil
                                                success:^(NSURLSessionDataTask *task, id responseObject)
            {
                NSError* error;
                ChildsResponse* response = [[ChildsResponse alloc]initWithDictionary:responseObject error:&error];
                
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

+(NSURLSessionTask*)pairDevice:(NSString*)uuid
                     withChild:(NSString*)childUUID
               usingDeviceName:(NSString*)deviceName
              withSuccessBlock:(void(^)(PairChildResponse*))successBlock
                  failureBlock:(void(^)(NSError*))failureBlock
{
    return [[self sharedManager].apiJSONSessionManager POST:kChildSetRequest
                                             parameters:@{kChildUUIDParam:childUUID,kDeviceUUIDParam:uuid,kDeviceLabelParam:deviceName}
                                                success:^(NSURLSessionDataTask *task, id responseObject)
            {
                NSError* jsonError;
                PairChildResponse* response = [[PairChildResponse alloc]initWithDictionary:responseObject error:&jsonError];
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
