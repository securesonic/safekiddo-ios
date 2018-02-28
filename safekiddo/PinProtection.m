//
//  PinProtection.m
//  safekiddo
//
//  Created by Jakub Długosz on 30.01.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "PinProtection.h"
#import <SSKeychain/SSKeychain.h>

#define kServiceName    @"defaultService"
#define kPINTriesName   @"kPINTriesName"

#define kTimeOutDateName @"kTimeOutDateName"

int const kPINProtectionMaxTriesLeft = 3;
int const kPINProtectionTimeoutSeconds = 60;

static PinProtection* _pinProtection;

@implementation PinProtection

+(PinProtection*)sharedPinProtection
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _pinProtection = [PinProtection new];
    });
    
    return _pinProtection;
}


-(int)triesLeft
{
    return [[SSKeychain passwordForService:kServiceName account:kPINTriesName] intValue];
}

-(void)setTriesLeft:(int)triesLeft
{
    [SSKeychain setPassword:@(triesLeft).stringValue forService:kServiceName account:kPINTriesName];
}

-(NSDate *)timeOutDate
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:kTimeOutDateName];
}

-(void)setTimeOutDate:(NSDate *)timeOutDate
{
    [[NSUserDefaults standardUserDefaults] setObject:timeOutDate forKey:kTimeOutDateName];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
