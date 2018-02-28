//
//  SessionManager.h
//  safekiddo
//
//  Created by Jakub Długosz on 16.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>




/**
 *  Class is responsible for maintaining a API session
 */
@interface NetworkSessionManager : NSObject

+(NetworkSessionManager*)sharedManager;

-(void)applicationStartWithCompletionBlock:(void(^)(void))completionBlock;

-(void)registerAPNSToken:(NSData*)token;


@end
