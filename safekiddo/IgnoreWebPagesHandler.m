//
//  IgnoreWebPagesHandler.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 23.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "IgnoreWebPagesHandler.h"

@interface IgnoreWebPagesHandler()

@property(readonly,nonatomic)NSArray* urlIgnoreListArray;

@end

@implementation IgnoreWebPagesHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _urlIgnoreListArray = @[
                                @"api.safekiddo.com"
                                ];
    }
    return self;
}

-(BOOL)shouldIgnoreURL:(NSURL*)url withHandler:(void(^)(NSString* currentTitle,NSURL* currentURL))handler
{
    BOOL shouldIgnore = NO;
    
    for (NSString* string in self.urlIgnoreListArray)
    {
        if([url.absoluteString rangeOfString:string].location != NSNotFound)
        {
            shouldIgnore = YES;
            break;
        }
    }
    
    return shouldIgnore;
}


@end
