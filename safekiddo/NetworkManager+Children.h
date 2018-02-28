//
//  NetworkManager+Children.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "ChildsResponse.h"
#import "PairChildResponse.h"
@interface NetworkManager (Children)

/**
 *  Retrieves a list of children for a user
 *
 *  @param successBlock Block called when operation is a success
 *  @param failureBlock Block called when operation is a failure
 *
 *  @return Session task
 */
+(NSURLSessionTask*)childsWithSuccessBlock:(void(^)(ChildsResponse*))successBlock
                              failureBlock:(void(^)(NSError*))failureBlock;


+(NSURLSessionTask*)pairDevice:(NSString*)uuid
                     withChild:(NSString*)childUUID
               usingDeviceName:(NSString*)deviceName
              withSuccessBlock:(void(^)(PairChildResponse*))successBlock
                  failureBlock:(void(^)(NSError*))failureBlock;

@end
