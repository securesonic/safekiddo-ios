//
//  loginTests.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NetworkManager+Authentication.h"
#import <XCTAsyncTestCase/XCTAsyncTestCase.h>
@interface authenticationTests : XCTAsyncTestCase

@property(strong,nonatomic)NSString* username;
@property(strong,nonatomic)NSString* password;

@property(strong,nonatomic)NSString* pin;

@end

@implementation authenticationTests

- (void)setUp {
    [super setUp];
    
    self.username = @"jdlugosz@test.com";
    self.password = @"jdlugosz";
    
    self.pin = @"1111";
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)test_1_FailedLogin {
    
    [self prepare];
    [NetworkManager loginWithLogin:@"xxxx" password:@"yyyy" successBlock:^(LoginResponse *response)
    {
        int result = kXCTUnitWaitStatusFailure;
        if(response)
        {
            if(response.success && !response.success.boolValue)
            {
                result = kXCTUnitWaitStatusSuccess;
            }
        }
        [self notify:result];
    } failureBlock:^(NSError * error)
    {
        [self notify:kXCTUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.f];
}

-(void)test_2_SuccessLogin
{
    
    [self prepare];
    [NetworkManager loginWithLogin:self.username password:self.password successBlock:^(LoginResponse * response)
     {
         int result = kXCTUnitWaitStatusFailure;
         if(response)
         {
             if(response.success && response.success.boolValue)
             {
                 if([self.pin isEqualToString:response.pin])
                 {
                     result = kXCTUnitWaitStatusSuccess;
                 }
             }
         }
         [self notify:result];
     } failureBlock:^(NSError *error)
     {
         [self notify:kXCTUnitWaitStatusFailure];
     }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.f];
}

-(void)test_3_SuccessLogout
{
    [self prepare];
    [NetworkManager logoutWithSuccessBlock:^(Response* response){
        
        int result = kXCTUnitWaitStatusFailure;
        if(response.success && response.success.boolValue)
        {
            result = kXCTUnitWaitStatusSuccess;
        }
        [self notify:result];
        
    } failureBlock:^(NSError* error){
        NSLog(@"%@",error);
        [self notify:kXCTUnitWaitStatusFailure];
    }];
    
    [self waitForStatus:kXCTUnitWaitStatusSuccess timeout:5.f];
}

@end
