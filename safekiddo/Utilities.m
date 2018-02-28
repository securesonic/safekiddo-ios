//
//  Utilities.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 03.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Utilities.h"
#import <SSKeychain/SSKeychain.h>


#define kProfilePIN @"profilePIN"

#define kServiceName @"defaultService"
#define kAccountName @"defaultAccount"

#define kUUIDAccountName @"uuidAccount"


#define kUsernameName @"username"
#define kPasswordName   @"password"
#define kChildUUIDName @"childUUID"
#define kChildName @"childName"
#define kHeartBeat @"heartBeat"

@implementation Utilities

+(NSString*)documentsFolderPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

NSString* const kCreateAccountAddress = @"https://my.safekiddo.com/register";


+(void)storeProfilePin:(NSString*)pin
{
       [SSKeychain setPassword:pin forService:kServiceName account:kProfilePIN];
}

+(NSString*)retrieveProfilePin
{
    return [SSKeychain passwordForService:kServiceName account:kProfilePIN];
}

+(void)storePin:(NSString*)pin
{
    [SSKeychain setPassword:pin forService:kServiceName account:kAccountName];
}

+(NSString*)retrievePin
{
   return [SSKeychain passwordForService:kServiceName account:kAccountName];
}

+(void)storePassword:(NSString*)password
{
     [SSKeychain setPassword:password forService:kServiceName account:kPasswordName];
}
+(void)storeUsername:(NSString*)username
{
     [SSKeychain setPassword:username forService:kServiceName account:kUsernameName];
}

+(NSString*)retrievePassword
{
      return [SSKeychain passwordForService:kServiceName account:kPasswordName];
}
+(NSString*)retrieveUsername
{
      return [SSKeychain passwordForService:kServiceName account:kUsernameName];
}

+(void)storeChildUUID:(NSString*)uuid
{
    [SSKeychain setPassword:uuid forService:kServiceName account:kChildUUIDName];
}

+(void)storeChildName:(NSString*)childName
{
    [[NSUserDefaults standardUserDefaults] setValue:childName forKey:kChildName];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
+(NSString*)childName
{
   return [[NSUserDefaults standardUserDefaults] valueForKey:kChildName];
}


static dispatch_once_t onceToken;
static NSDateFormatter* heartBeatDateFormatter;

+(void)storeHeartBeat:(NSDate*)heartBeat
{
    dispatch_once(&onceToken, ^{
        heartBeatDateFormatter = [[NSDateFormatter alloc]init];
    });
    
    [SSKeychain setPassword:[heartBeatDateFormatter stringFromDate:heartBeat] forService:kServiceName account:kHeartBeat];
}
+(NSDate*)retrieveHeartBeat
{
    dispatch_once(&onceToken, ^{
        heartBeatDateFormatter = [[NSDateFormatter alloc]init];
    });
    return [heartBeatDateFormatter dateFromString:[SSKeychain passwordForService:kServiceName account:kHeartBeat]];
}

+(NSString*)retrieveChildUUID
{
    return [SSKeychain passwordForService:kServiceName account:kChildUUIDName];
}


+(NSString*)uuid
{
    NSString* uuid = [SSKeychain passwordForService:kServiceName account:kUUIDAccountName];
    if(!uuid)
    {
        uuid = [[NSUUID UUID] UUIDString];
        [SSKeychain setPassword:uuid forService:kServiceName account:kUUIDAccountName];
    }
    return uuid;
}

+(BOOL)isLoggedIn
{
    return [self retrievePassword] != nil;
}

+(NSString*)desktopUserAgent
{
    return @"User-Agent	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/600.1.25 (KHTML, like Gecko) QuickLook/5.0";
}

+(NSString *)deviceName
{
    return [[UIDevice currentDevice] name];
}

+(NSString *)urlRegex
{
    return @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
}


static NSString* acceptLanguageVar;

+(NSString*)acceptLangugage
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableString* acceptedString = [[NSMutableString alloc]init];
        double i=0;
        for(NSString* lang in [NSLocale preferredLanguages])
        {
            if(i>=0.5)
            {
                [acceptedString appendFormat:@"%@;q=%0.1f ,",lang, 1-i];
                i+=0.1;
            }
        }
        acceptLanguageVar = [acceptedString copy];
    });
    return acceptLanguageVar;
}
@end
