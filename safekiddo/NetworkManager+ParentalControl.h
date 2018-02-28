//
//  NetworkManager+ParentalControl.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkManager.h"
#import "ParentalControlResponse.h"
typedef enum
{
    UserActionNoLog =0,
    UserActionLog =1,
    UserActionCategory=2
}UserActionType;

@interface NetworkManager (ParentalControl)

+(NSURLSessionDataTask*)checkURL:(NSURL*)url forChild:(NSString*)childUUID requestType:(UserActionType)actionType withSuccess:(void(^)(ParentalControlResponse*))successBlock failure:(void(^)(NSError*))failureBlock;

@end
