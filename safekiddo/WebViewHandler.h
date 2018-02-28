//
//  WebViewHandler.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WebViewHandler;
@protocol WebViewHandlerDelegate <NSObject>

@optional
-(void)webViewHandlerDidStartProgress:(WebViewHandler*)handler;
-(void)webViewHandler:(WebViewHandler*)handler progressChanged:(CGFloat)progress;
-(void)webViewHandlerDidEndProgress:(WebViewHandler *)handler;


-(void)webViewHandler:(WebViewHandler *)handler userRequestedURL:(NSURL*)url;
-(void)webViewHandler:(WebViewHandler *)handler loadedURL:(NSURL*)url title:(NSString*)title;
@end

@interface WebViewHandler : NSObject

@property(readonly,nonatomic)UIWebView* webView;

-(id)initWithWebView:(UIWebView*)webView delegate:(id<WebViewHandlerDelegate>)delegate;
-(void)openURL:(NSURL*)url;

-(NSURL*)currentURL;
-(NSString*)currentTitle;

@end
