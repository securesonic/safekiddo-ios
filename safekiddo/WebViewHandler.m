//
//  WebViewHandler.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WebViewHandler.h"
#import "SafeURLProtocol.h"
#import "RequestTracker.h"
#import "IgnoreWebPagesHandler.h"

#define kIgnorePageTitle @"SafeKiddo"

@interface WebViewHandler()<UIWebViewDelegate,RequestTrackerDelegate>

@property(strong,nonatomic)UIWebView* webView;
@property(weak,nonatomic)id<WebViewHandlerDelegate>delegate;

@property(strong,nonatomic)NSTimer* progressTimer;
@property(assign,nonatomic)CGFloat currentProgress;
@property(assign,nonatomic)CGFloat currentMaxProgress;

-(void)progressTimerCallback;

@property (strong,nonatomic) IgnoreWebPagesHandler* ignoreWebPagesHandler;

@end

#define kParentalControlStartPercentage 5.f //step 1
#define kParentalControlEndPercentage 15.f // step 2
#define kPageLoadEndPercentage 50.f       //  step 3
#define kPageAssetsLoadMaxPercentage 90.f//   step 4

#define kProgressUpdateTimeInterval 0.3f
#define kProgressUpdateTimerValue 5.f


@implementation WebViewHandler

-(id)initWithWebView:(UIWebView*)webView delegate:(id<WebViewHandlerDelegate>)delegate;
{
    self = [super init];
    if(self)
    {
        self.webView = webView;
        self.webView.delegate = self;
        self.delegate = delegate;
        self.ignoreWebPagesHandler = [[IgnoreWebPagesHandler alloc]init];
    }
    
    return self;
}

-(void)dealloc
{
}

#pragma mark - Public -

-(void)openURL:(NSURL*)url
{
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url];
     [SafeURLProtocol makeRequest:request userAction:YES withRequestTracker:[[RequestTracker alloc]initWithDelegate:self]];
    [self.webView loadRequest:request];
    
    if([self.delegate respondsToSelector:@selector(webViewHandler:userRequestedURL:)])
    {
        [self.delegate webViewHandler:self userRequestedURL:url];
    }
}

-(NSURL*)currentURL
{
    NSURL*  url = [NSURL URLWithString:[self.webView stringByEvaluatingJavaScriptFromString:@"window.location.href"]];
    
    return url;
}

-(NSString*)currentTitle
{
    NSString* title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if([title isEqualToString:kIgnorePageTitle])
    {
        return @"";
    }else
    {
        return title;
    }
}

#pragma mark - UIWebViewDelegate -

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        NSMutableURLRequest* requestMutableCopy = [request mutableCopy];
        
        [SafeURLProtocol makeRequest:requestMutableCopy userAction:YES withRequestTracker:[[RequestTracker alloc]initWithDelegate:self]];
        [webView loadRequest:requestMutableCopy];
        
        if([self.delegate respondsToSelector:@selector(webViewHandler:userRequestedURL:)])
        {
            [self.delegate webViewHandler:self userRequestedURL:requestMutableCopy.URL];
        }
        if(![self.ignoreWebPagesHandler shouldIgnoreURL:[self currentURL] withHandler:nil])
        {
            self.ignoreWebPagesHandler.lastTitle = [self currentTitle];
            self.ignoreWebPagesHandler.lastURL = [self currentURL];
        }
        
        return NO;
    }
    else
    {
        
        

    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if([self.delegate respondsToSelector:@selector(webViewHandlerDidStartProgress:)])
    {
        [self.delegate webViewHandlerDidStartProgress:self];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.progressTimer invalidate];
    if([self.delegate respondsToSelector:@selector(webViewHandlerDidEndProgress:)])
    {
        [self.delegate webViewHandlerDidEndProgress:self];
    }
    
    
    BOOL shouldIgnore = [self.ignoreWebPagesHandler shouldIgnoreURL:self.currentURL withHandler:nil] ||
    [self currentTitle].length == 0;
    
    if(!shouldIgnore)
    {
        if([self.delegate respondsToSelector:@selector(webViewHandler:loadedURL:title:)])
        {
            [self.delegate webViewHandler:self loadedURL:[self currentURL] title:[self currentTitle]];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.progressTimer invalidate];
    //NSLog(@"%@",@"Error loading");
    //NSLog(@"%@",error);
    if([self.delegate respondsToSelector:@selector(webViewHandlerDidEndProgress:)])
    {
        [self.delegate webViewHandlerDidEndProgress:self];
    }
}

#pragma mark - Private -

-(void)progressTimerCallback
{
    self.currentProgress = MIN(self.currentProgress+kProgressUpdateTimerValue, self.currentMaxProgress);
    if([self.delegate respondsToSelector:@selector(webViewHandler:progressChanged:)])
    {
        [self.delegate webViewHandler:self progressChanged:self.currentProgress/100.f];
    }
}

#pragma mark - RequestTrackerDelegate -

-(void)requestTrackerDidStartParentalControl:(RequestTracker*)tracker
{
    if([self.delegate respondsToSelector:@selector(webViewHandler:progressChanged:)])
    {
        [self.delegate webViewHandler:self progressChanged:kParentalControlStartPercentage/100.f];
    }
}
-(void)requestTrackerDidEndParentalControl:(RequestTracker *)tracker
{
    if([self.delegate respondsToSelector:@selector(webViewHandler:progressChanged:)])
    {
        [self.delegate webViewHandler:self progressChanged:kParentalControlEndPercentage/100.f];
    }
    self.currentProgress = kParentalControlEndPercentage;
    self.currentMaxProgress = kPageLoadEndPercentage;
    [self.progressTimer invalidate];
    self.progressTimer =[NSTimer scheduledTimerWithTimeInterval:kProgressUpdateTimeInterval target:self selector:@selector(progressTimerCallback) userInfo:nil repeats:YES];
}

-(void)requestTrackerDidEndPageLoad:(RequestTracker*)tracker
{
    if([self.delegate respondsToSelector:@selector(webViewHandler:progressChanged:)])
    {
        [self.delegate webViewHandler:self progressChanged:kPageLoadEndPercentage/100.f];
    }
    self.currentProgress = kPageLoadEndPercentage;
    self.currentMaxProgress = kPageAssetsLoadMaxPercentage;
}

@end
