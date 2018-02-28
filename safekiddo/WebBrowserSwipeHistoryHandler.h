//
//  WebBrowserSwipeHistoryHandler.h
//  safekiddo
//
//  Created by Jakub Długosz on 13.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebBrowserSwipeHistoryHandler : NSObject

-(id)initWithWebView:(UIWebView*)webView leadingLayoutConstraint:(NSLayoutConstraint*)constraint;


-(void)webviewWillNavigateBack;
-(void)webviewWillNavigateForward;
-(void)webviewWillNavigateNew;

-(void)webviewLoaded;

@end
