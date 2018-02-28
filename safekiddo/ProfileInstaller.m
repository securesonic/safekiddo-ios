//
//  ProfileInstaller.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "ProfileInstaller.h"
#import "Utilities.h"
#import "HTTPServerUttilities.h"
#import <SSKeychain/SSKeychain.h>
NSString* const kPinAttribute = @"{pin}";

static ProfileInstaller* _installer;

@implementation ProfileInstaller

+(ProfileInstaller*)sharedInstaller
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _installer = [ProfileInstaller new];
    });
    
    return _installer;
}

-(BOOL)isProfileInstalled
{
    NSString* certPath = [[NSBundle mainBundle] pathForResource:@"Certyfikat" ofType:@"cer"];
    if (certPath==nil)
    {
        return NO;
    }

    NSData* certData = [NSData dataWithContentsOfFile:certPath];
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, (__bridge CFDataRef) certData);
    SecPolicyRef policy = SecPolicyCreateBasicX509();
    SecTrustRef trust;
    OSStatus err = SecTrustCreateWithCertificates((__bridge CFArrayRef) [NSArray arrayWithObject:(__bridge id)cert], policy, &trust);
    SecTrustResultType trustResult = -1;
    err = SecTrustEvaluate(trust, &trustResult);
    CFRelease(trust);
    CFRelease(policy);
    CFRelease(cert);

    if(trustResult == kSecTrustResultUnspecified)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(void)installProfileWithPin:(NSString*)pin
{
    
    NSString* profilePath = [[NSBundle mainBundle] pathForResource:@"safekiddo" ofType:@"mobileconfig"];

#if DEBUG
    profilePath = [[NSBundle mainBundle] pathForResource:@"safekiddo-debug" ofType:@"mobileconfig"];
#endif
    
    NSError* error;
    NSMutableString* profile = [[NSMutableString alloc]initWithContentsOfFile:profilePath encoding:NSUTF8StringEncoding error:&error];
    
    if(error)
    {
        NSLog(@"%@",error);
        return;
    }
    
    [profile replaceOccurrencesOfString:kPinAttribute withString:pin options:NSCaseInsensitiveSearch range:(NSRange){0,profile.length}];
    
    
    NSData* profileData = [profile dataUsingEncoding:NSUTF8StringEncoding];
    
    [HTTPServerUttilities storeFile:profileData named:@"safekiddo.mobileconfig"];
    [HTTPServerUttilities startServer];
    [HTTPServerUttilities openFileInSafari:@"safekiddo.mobileconfig"];
}

-(void)uninstallProfile
{
    NSString* profilePath = [[NSBundle mainBundle] pathForResource:@"safekiddo_clear" ofType:@"mobileconfig"];
    
    NSError* error;
    NSMutableString* profile = [[NSMutableString alloc]initWithContentsOfFile:profilePath encoding:NSUTF8StringEncoding error:&error];
    
    if(error)
    {
        NSLog(@"%@",error);
        return;
    }
    
    NSData* profileData = [profile dataUsingEncoding:NSUTF8StringEncoding];
    
    [HTTPServerUttilities storeFile:profileData named:@"safekiddo_clear.mobileconfig"];
    [HTTPServerUttilities startServer];
    [HTTPServerUttilities openFileInSafari:@"safekiddo_clear.mobileconfig"];
}


@end
