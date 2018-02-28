//
//  SafeSearchCookie.m
//  safekiddo
//
//  Created by Jakub Długosz on 17.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "SafeSearchCookie.h"

@interface SafeSearchCookie()

-(NSHTTPCookie*)getSafeSearchCookie;
-(NSHTTPCookie*)createSafeSearchCookie:(NSString*)urlString;
@end


@implementation SafeSearchCookie

-(NSString *)enforceSafeSearch:(NSString *)inputSearchQuery
{
    /* handle cookies */
    NSHTTPCookie* cookie = [self getSafeSearchCookie];
    
    if(cookie)
    {
        NSString* value = [cookie value];
    
        if([value rangeOfString:[NSString stringWithFormat:@"%@=%@",self.cookieParameterName,self.cookieParameterValue]].location == NSNotFound)
        {
            value = [value stringByAppendingFormat:@"&%@=%@",self.cookieParameterName,self.cookieParameterValue];
            NSMutableDictionary* cookieProperties = [[cookie properties] mutableCopy];
            [cookieProperties setObject:value forKey:NSHTTPCookieValue];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
        }
        
    }
    else
    {
        cookie = [self createSafeSearchCookie:inputSearchQuery];
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
    }
    
    
    
    return inputSearchQuery;
}

-(NSHTTPCookie*)createSafeSearchCookie:(NSString*)urlString;
{
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableDictionary* cookieProperties = [NSMutableDictionary new];
    
    [cookieProperties setObject:self.cookieName forKey:NSHTTPCookieName];
    [cookieProperties setObject:[NSString stringWithFormat:@"%@=%@",self.cookieParameterName,self.cookieParameterValue] forKey:NSHTTPCookieValue];
    [cookieProperties setObject:url.host forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:url.host forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:[[NSDate date] dateByAddingTimeInterval:2629743] forKey:NSHTTPCookieExpires];
    
    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    
    return cookie;
}

-(NSHTTPCookie*)getSafeSearchCookie
{
    for(NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        if([[cookie name] isEqualToString:self.cookieName] &&
           [[cookie domain] rangeOfString:self.domainName].location != NSNotFound)
        {
            NSLog(@"%@",cookie);
            return cookie;
        }
    }
    return nil;
}


@end
