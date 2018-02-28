//
//  NetworkManager+ParentalControl.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager+ParentalControl.h"

@implementation NetworkManager (ParentalControl)

+(NSURLSessionDataTask*)checkURL:(NSURL*)url forChild:(NSString*)childUUID requestType:(UserActionType)actionType withSuccess:(void(^)(ParentalControlResponse*))successBlock failure:(void(^)(NSError*))failureBlock
{
   AFHTTPRequestSerializer* serialzier = [[self sharedManager].mdmSessionManager requestSerializer];
    
    @synchronized(self)
    {
        [serialzier setValue:@(actionType).stringValue forHTTPHeaderField:kUserActionParam];
        [serialzier setValue:[url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:kRequestParam];
        [serialzier setValue:childUUID forHTTPHeaderField:kUserIdParam];
        
       NSURLSessionDataTask* task =  [[self sharedManager].mdmSessionManager GET:kChildCheckRequest parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
        {
            NSHTTPURLResponse* httpResponse = (id)  task.response;
            
            ParentalControlResponse* pcResponse = [ParentalControlResponse new];
            pcResponse.result = httpResponse.allHeaderFields[@"Result"];
            pcResponse.usedProfileId = httpResponse.allHeaderFields[@"Used-profile-id"];
            pcResponse.usedProfileName = httpResponse.allHeaderFields[@"Used-profile-name"];
            pcResponse.categoryGroupId = httpResponse.allHeaderFields[@"Category-group-id"];
            pcResponse.categoryGroupName = httpResponse.allHeaderFields[@"Category-group-name"];
            
            if(successBlock)
            {
                successBlock(pcResponse);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if(failureBlock)
            {
                failureBlock(error);
            }
        }];
        
        [serialzier setValue:nil forHTTPHeaderField:kUserActionParam];
        [serialzier setValue:nil forHTTPHeaderField:kRequestParam];
        [serialzier setValue:nil forHTTPHeaderField:kUserIdParam];
        
        
        return task;
    }
}

@end
