//
//  NetworkManager+WebPages.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (WebPages)

+(NSURLSessionTask*)homePageWithSuccessBlock:(void(^)(NSString*))successBlock
                              failureBlock:(void(^)(NSError*))failureBlock;

+(NSURLSessionTask*)blockPageWithSKCode:(NSString*)skCode
                               forChild:(NSString*)childUUID
                             requestURL:(NSURL*)url
                           successBlock:(void(^)(NSData*,NSURLResponse*))successBlock
                                failureBlock:(void(^)(NSError*))failureBlock;


@end
