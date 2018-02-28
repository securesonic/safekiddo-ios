//
//  SessionManager.m
//  safekiddo
//
//  Created by Jakub Długosz on 16.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "NetworkSessionManager.h"
#import "NetworkManager+Authentication.h"
#import "NetworkManager+Children.h"
#import "NetworkManager+Hearbeat.h"
#import "NetworkManager+Settings.h"

#import "Utilities.h"
#import "Constants.h"
#import "Child.h"
static NetworkSessionManager* _instance;
const NSInteger kHeartbeatFailureDispatch = 20;
const NSInteger kGetChildrenFailureDispatch = 20;

const NSInteger kSetAPNSTokenFailureDispatch = 20;

@interface NetworkSessionManager()

@property(strong,nonatomic)NSString* currentAPNSToken;

@property(strong,nonatomic)NSTimer* heartbeatTimer;

@end

@implementation NetworkSessionManager

+(NetworkSessionManager *)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [NetworkSessionManager new];
    });
    return _instance;
}

-(void)applicationStartWithCompletionBlock:(void(^)(void))completionBlock
{
    id logoutFailureBlock = ^(NSError* error){
        //Go hardcore or go home: We log the user out.
        [Utilities storePassword:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:kRestartApplicationNotification object:nil];
        
    };
    
    
    [NetworkManager loginWithLogin:[Utilities retrieveUsername]
                          password:[Utilities retrievePassword]
                      successBlock:^(LoginResponse *response)
     {
         NSString* childUUID = [Utilities retrieveChildUUID];
         if(childUUID)
         {
             [NetworkManager pairDevice:[Utilities uuid] withChild:childUUID usingDeviceName:[Utilities deviceName] withSuccessBlock:^(PairChildResponse * response)
              {
                  //fallback - all is good
                  completionBlock();
                  
                  //do some additional tasks needed but not critical
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [self heartbeatTimerAction];
                      [self refreshChildrenList];
                  });
                  
              } failureBlock:logoutFailureBlock];
         }
         
         [Utilities storePin:response.pin];
         
         
     } failureBlock:logoutFailureBlock];
}

-(void)registerAPNSToken:(NSData*)token
{

    
    NSString* stringToken = [token base64EncodedStringWithOptions:0];
    
    
    if(self.currentAPNSToken == nil ||
       [self.currentAPNSToken isEqualToString:stringToken])
    {
        self.currentAPNSToken = stringToken;
        
        [NetworkManager setPushToken:stringToken successBlock:^(Response *response)
         {
             if(response.success)
             {
                 self.currentAPNSToken = nil;
             }
             else
             {
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSetAPNSTokenFailureDispatch * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self registerAPNSToken:token];
                 });
             }
         } failureBlock:^(NSError *error) {
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kSetAPNSTokenFailureDispatch * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self registerAPNSToken:token];
             });
         }];
        
    }
    
}

#pragma mark - private -

-(void)refreshChildrenList
{
    NSLog(@"%@",@"Will download children");
    [NetworkManager childsWithSuccessBlock:^(ChildsResponse *childResponse)
     {
         NSLog(@"%@",@"Did download children");
         if(childResponse.success && childResponse.success.boolValue)
         {
             NSMutableDictionary* childDictionary = [NSMutableDictionary dictionary];
             NSMutableDictionary* childAvatarDictionary = [NSMutableDictionary dictionary];
             for(Child* child in childResponse.childs)
             {
                 [childDictionary setObject:child.name forKey:child.uuid];
                 [childAvatarDictionary setObject:child.avatarUrl?child.avatarUrl:[NSNull null] forKey:child.uuid];
             }

             NSUserDefaults* userDefaults = [[NSUserDefaults alloc]initWithSuiteName:kUserDefaultsSharedId];
             
             [userDefaults setObject:childDictionary forKey:kChildrenKey];
             [userDefaults setObject:childAvatarDictionary forKey:kChildrenAvatarKey];
             [userDefaults synchronize];

         }
         
     } failureBlock:^(NSError * error)
     {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kGetChildrenFailureDispatch * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self refreshChildrenList];
         });
     }];
}

-(void)heartbeatTimerAction
{
    [self.heartbeatTimer invalidate];
    
    NSLog(@"%@",@"Heartbeat start");
    [NetworkManager heartbeatWithDeviceUUID:[Utilities uuid]
                               successBlock:^(HeartbeatResponse *response)
     {
         NSLog(@"%@",@"Heartbeat finished");
         if(response.success.boolValue)
         {
             [Utilities storeHeartBeat:[NSDate dateWithTimeIntervalSinceNow:response.heartbeatInterval.intValue]];
             self.heartbeatTimer = [NSTimer scheduledTimerWithTimeInterval:response.heartbeatInterval.intValue target:self selector:@selector(heartbeatTimerAction) userInfo:nil repeats:NO];
         }
         else
         {
             if(response.blockAccess.boolValue)
             {
                 [Utilities storePassword:nil];
                 [[NSNotificationCenter defaultCenter]postNotificationName:kRestartApplicationNotification object:nil];
             }
         }
         
     } failureBlock:^(NSError *error)
     {
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kHeartbeatFailureDispatch * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self heartbeatTimerAction];
         });
     }];
}




@end
