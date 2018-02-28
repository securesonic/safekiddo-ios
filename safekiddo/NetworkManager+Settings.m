//
//  NetworkManager+Push.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 26.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager+Settings.h"
#import "Utilities.h"
@implementation NetworkManager (Settings)
//_apiJSONSessionManagerv2

+(NSURLSessionTask*)setPushToken:(NSString*)pushToken
                    successBlock:(void(^)(Response*))successBlock
                    failureBlock:(void(^)(NSError*))failureBlock
{
    
    
    return [[[self sharedManager]apiJSONSessionManagerv2] POST:[NSString stringWithFormat:kSetSettingsRequestFormat,[Utilities uuid]]
                                                    parameters:@{kSettingsPushTokenParam:pushToken}
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
                                                           
                                                       }
                                                       failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                           if(failureBlock)
                                                           {
                                                               failureBlock(error);
                                                           }
                                                       }];
}
@end
