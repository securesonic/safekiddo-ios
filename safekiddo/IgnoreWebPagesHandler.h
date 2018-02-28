//
//  IgnoreWebPagesHandler.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 23.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IgnoreWebPagesHandler;

/**
 *  Class designed to handle a list of igonored web pages - web pages that are ignored - shuld be called but not displayed in history, or url search bar, etc. example might be: api.safekiddo.com/block call
 */
@interface IgnoreWebPagesHandler : NSObject


@property(strong,nonatomic)NSString* lastTitle;
@property(strong,nonatomic)NSURL* lastURL;
@property(assign,nonatomic)BOOL isBackAction;

-(BOOL)shouldIgnoreURL:(NSURL*)url withHandler:(void(^)(NSString* currentTitle,NSURL* currentURL))handler;

@end
