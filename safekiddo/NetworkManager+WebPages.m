//
//  NetworkManager+WebPages.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager+WebPages.h"

@implementation NetworkManager (WebPages)

+(NSURLSessionTask*)homePageWithSuccessBlock:(void(^)(NSString*))successBlock
                                failureBlock:(void(^)(NSError*))failureBlock
{
    
     return [[[self sharedManager] apiNSStringSessionManager] GET:kHomePageRequest parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        NSString* response = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if(response)
        {
            if(successBlock)
            {
                successBlock(response);
            }
        }
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
         if(failureBlock)
         {
             failureBlock(error);
         }
     }];
}

+(NSURLSessionTask*)blockPageWithSKCode:(NSString*)skCode
                               forChild:(NSString*)childUUID
                             requestURL:(NSURL*)url
                           successBlock:(void(^)(NSData*,NSURLResponse*))successBlock
                           failureBlock:(void(^)(NSError*))failureBlock
{
    @synchronized(self)
    {
        AFHTTPRequestSerializer* serialzier = [[self sharedManager].mdmSessionManager requestSerializer];
        
        [serialzier setValue:skCode forHTTPHeaderField:kSKCodeParam];
        [serialzier setValue:childUUID forHTTPHeaderField:kChildUUIDParam];
        [serialzier setValue:[[url absoluteString] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forHTTPHeaderField:kSKURLParam];
        
        NSURLSessionTask* task = [[[self sharedManager] apiNSStringSessionManager] GET:kBlockRequest parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
                                  {
                                          if(successBlock)
                                          {
                                              successBlock(responseObject,task.response);
                                          }
                                  } failure:^(NSURLSessionDataTask *task, NSError *error)
                                  {
                                      NSData* errorData = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
                                      if(errorData)
                                      {
                                          if(successBlock)
                                          {
                                              successBlock(errorData,task.response);
                                          }
                                      }
                                      else
                                      {
                                          if(failureBlock)
                                          {
                                              failureBlock(error);
                                          }
                                      }
                                  }];
        
        [serialzier setValue:nil forHTTPHeaderField:kSKCodeParam];
        [serialzier setValue:nil forHTTPHeaderField:kSKURLParam];
        [serialzier setValue:nil forHTTPHeaderField:kChildUUIDParam];
        return task;
    }

}

@end
