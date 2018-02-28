//
//  NetworkManager+Register.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "RegisterRequestData.h"
#import "RegisterResponse.h"
@interface NetworkManager (Register)

+ (NSURLSessionTask *)registerData:(RegisterRequestData *)requestData successBlock:(void(^)(RegisterResponse*))successBlock failureBlock:(void(^)(NSError*))failureBlock;

@end
