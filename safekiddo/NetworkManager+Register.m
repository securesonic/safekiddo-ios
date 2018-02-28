//
//  NetworkManager+Register.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager+Register.h"
#import "RegisterResponse.h"

@implementation NetworkManager (Register)

+ (NSURLSessionTask *)registerData:(RegisterRequestData *)requestData successBlock:(void(^)(RegisterResponse*))successBlock failureBlock:(void(^)(NSError*))failureBlock;
{

    
    return [[self sharedManager]
                .apiJSONSessionManagerv2 POST:kRegisterRequest
        parameters:[requestData requestParamters]
        success:^(NSURLSessionDataTask *task, id responseObject) {

            NSError* jsonError;
            RegisterResponse* registerResponse = [[RegisterResponse alloc]initWithDictionary:responseObject error:&jsonError];
            
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
                    successBlock(registerResponse);
                }
            }
            
            
        }
        failure:^(NSURLSessionDataTask *task, NSError *error){
            if(failureBlock)
            {
                failureBlock(error);
            }
        }];
}

@end
