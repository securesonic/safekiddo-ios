//
//  NetworkManager+Push.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 26.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "Response.h"

@interface NetworkManager (Settings)

+(NSURLSessionTask*)setPushToken:(NSString*)pushToken
                    successBlock:(void(^)(Response*))successBlock
                    failureBlock:(void(^)(NSError*))failureBlock;


/*
 +(NSURLSessionTask*)blockPageWithSKCode:(NSString*)skCode
                               forChild:(NSString*)childUUID
                             requestURL:(NSURL*)url
                           successBlock:(void(^)(NSData*,NSURLResponse*))successBlock
                           failureBlock:(void(^)(NSError*))failureBlock;
*/
@end
