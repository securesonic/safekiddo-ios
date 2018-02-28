//
//  SafeURLProtocol.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SafeURLProtocol.h"
#import "NetworkManager+ParentalControl.h"
#import "NetworkManager+WebPages.h"
#import "Utilities.h"
#import "Settings.h"
#import "SafeSearchAbstract.h"
#import "Settings+SafeSearch.h"
NSString* const kUserActionPropertyKey = @"UserActionKey";
NSString* const kSafeURLProtocolHandledKey = @"SafeURLProtocolHandledKey";
NSString* const kIgnoreSafeURLProtocolHTTPHeader = @"IgnoreSafeURLProtocolHTTPHeader";

NSString* const kProgressTrackerKey = @"ProgressTracker";

BOOL safeURLProtocolDebugMode = YES;


@interface SafeURLProtocol()<NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, strong) NSURLSessionTask* task;

-(void)enforceSafeSearch:(NSMutableURLRequest*)request;

@end

static NSArray* _urlWhiteListArray;


@implementation SafeURLProtocol

+(void)initialize
{
    [super initialize];
    _urlWhiteListArray = @[@"/blockaa", //javascript block function on safekiddo block page
                           @"data:image", //base64 image
                           @"http://ajax.googleapis.com/ajax/libs/jquery/1.10.2/jquery.min.js", //Disney
                           //@"http://www.googletagservices.com/tag/js/gpt_mobile.js",
                           //@"http://tredir.go.com/capmon/GetDE/?set=j&param=countryisocode&param=state&param=connection",
                           //@"http://tpc.googlesyndication.com/safeframe/1-0-0/html/container.html",
                           @"w88.go.com",  //http://w88.go.com/b/ss/wdgintpl/1/H.25.2/s78371731075458 //Disney,
                           @"safekiddo.com/api/v1/",
                           @"safekiddo.com/api/v2/"
                           ];
}

#pragma mark - public - 

+(BOOL)makeRequest:(NSMutableURLRequest*)request userAction:(BOOL)isUserAction withRequestTracker:(RequestTracker*)tracker;
{
    if([NSURLProtocol propertyForKey:kUserActionPropertyKey inRequest:request])
    {
        return YES;
    }
    else
    {
        [NSURLProtocol setProperty:@(isUserAction) forKey:kUserActionPropertyKey inRequest:request];
        
#warning Problem with Caching request
        /**
         *  It seems, that a propery can't be any object because the tracker can't be serialized. We sholud try to implement NSCoding in tracke object.
         */
        [NSURLProtocol setProperty:tracker forKey:kProgressTrackerKey inRequest:request];
        return NO;
    }
}

+(void)makeRequestSerializer:(AFHTTPRequestSerializer*)serializer requestsIgnoreSafeProtocol:(BOOL)ignoreProtocol
{
    [serializer setValue:@(ignoreProtocol).stringValue forHTTPHeaderField:kIgnoreSafeURLProtocolHTTPHeader];
}

+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"can init url: %@",request.URL);
    NSString* ignoreRequest = request.allHTTPHeaderFields[kIgnoreSafeURLProtocolHTTPHeader];
    if(ignoreRequest && ignoreRequest.boolValue)
    {
        return NO;
    }
    
    if([NSURLProtocol propertyForKey:kSafeURLProtocolHandledKey inRequest:request])
    {
        return NO;
    }
    
    for(NSString* whiteList in _urlWhiteListArray)
    {
        if([request.URL.absoluteString rangeOfString:whiteList].location != NSNotFound)
        {
            return NO;
        }
    }

       return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {

    NSMutableURLRequest *newRequest = [self.request mutableCopy];
    
    
    [NSURLProtocol setProperty:@(YES) forKey:kSafeURLProtocolHandledKey inRequest:newRequest];
    
    
    if(![Settings sharedSettings].useMobileUserAgent)
    {
        [newRequest setValue:[Utilities desktopUserAgent] forHTTPHeaderField:@"User-Agent"];
    }
    
    if(![[newRequest allHTTPHeaderFields] objectForKey:@"Accept-Language"])
    {
        [newRequest setValue:[Utilities acceptLangugage] forHTTPHeaderField:@"Accept-Language"];
    }
    
    NSNumber* userAction =  [NSURLProtocol propertyForKey:kUserActionPropertyKey inRequest:newRequest];
    
    RequestTracker* tracker = [NSURLProtocol propertyForKey:kProgressTrackerKey inRequest:newRequest];
    
    dispatch_async(dispatch_get_main_queue(), ^{
            [tracker.delegate requestTrackerDidStartParentalControl:tracker];
    });
    
    
    [self enforceSafeSearch:newRequest];
    
    self.task = [NetworkManager checkURL:newRequest.URL
                                forChild:[Utilities retrieveChildUUID]
                             requestType:userAction && userAction.boolValue? UserActionLog:UserActionNoLog
                             withSuccess:^(ParentalControlResponse *response)
    {
        [tracker.delegate requestTrackerDidEndParentalControl:tracker];
                                 if(response.result.intValue == Success)
                                 {
                                     
                                     self.connection = [NSURLConnection connectionWithRequest:newRequest delegate:self];
                                 }
                                 else
                                 {
                                     if(userAction && userAction.boolValue)
                                     {
                                         [NetworkManager blockPageWithSKCode:response.result
                                                                    forChild:[Utilities retrieveChildUUID]
                                                                  requestURL:newRequest.URL
                                                                successBlock:^(NSData *responseObject,NSURLResponse* response) {
                                                                    
                                                                    
                                                                    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                                                                    [self.client URLProtocol:self didLoadData:responseObject];
                                                                    [self.client URLProtocolDidFinishLoading:self];
                                                                    
                                                                } failureBlock:^(NSError *error) {
                                                                    [self.client URLProtocol:self didFailWithError:error];
                                                                }];
                                     }
                                     else
                                     {
                                         
                                         NSError* error = [NSError errorWithDomain:@"moja" code:0 userInfo:@{}];
                                         if(safeURLProtocolDebugMode)
                                         {
                                             NSLog(@"%@",error);
                                             NSLog(@"%@",response.result);
                                             NSLog(@"%@",newRequest);
                                         }
                                         [self.client URLProtocol:self didFailWithError:error];
                                     }
                                 }
                                 
                             } failure:^(NSError *error) {
                                 if(safeURLProtocolDebugMode)
                                 {
                                     NSLog(@"%@",error);
                                 }
                                 if(error.code != NSURLErrorCancelled)
                                 {
                                     [self.client URLProtocol:self didFailWithError:error];
                                 }
                             }];
    
}

- (void)stopLoading {
    [self.connection cancel];
    [self.task cancel];
    self.connection = nil;
    self.task = nil;
}


-(void)enforceSafeSearch:(NSMutableURLRequest*)request
{
    for(SafeSearchAbstract* safeSearch in [[Settings sharedSettings] arrayOfSearchRegex])
    {
        if([safeSearch regexMatch:request.URL])
        {
            request.URL = [NSURL URLWithString:[safeSearch enforceSafeSearch:request.URL.absoluteString]];
        }
    }
}

#pragma mark - NSURLConnectioData -


-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response
{
    if(response)
    {
        [self.client URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
    }
    
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.client URLProtocol:self didLoadData:data];
  
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    RequestTracker* tracker = [NSURLProtocol propertyForKey:kProgressTrackerKey inRequest:connection.originalRequest];
    [tracker.delegate requestTrackerDidEndPageLoad:tracker];
    [self.client URLProtocolDidFinishLoading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self.client URLProtocol:self didFailWithError:error];
}




@end
