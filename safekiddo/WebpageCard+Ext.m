//
//  WebpageCard+Ext.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 15.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "WebpageCard+Ext.h"


@interface __WeakWrapper : NSObject

@property(weak,nonatomic) WebpageCard* card;
@property(strong,nonatomic) UIViewController* viewController;

@end

@implementation __WeakWrapper

@end

static NSMutableArray* viewControllersArray;
static dispatch_once_t onceToken;

@implementation WebpageCard (Ext)

-(UIViewController *)viewController
{
    dispatch_once(&onceToken, ^{
        viewControllersArray = [NSMutableArray array];
    });
    
    for (int i = viewControllersArray.count-1; i>=0; i--)
    {
        __WeakWrapper* wrapper = viewControllersArray[i];
        if(wrapper.viewController == nil ||
           wrapper.card == nil)
        {
            [viewControllersArray removeObjectAtIndex:i];
        }
        else
        {
            if(wrapper.card == self)
            {
                return wrapper.viewController;
            }
        }
    }
    return nil;
}

-(void)setViewController:(UIViewController *)viewController
{
    dispatch_once(&onceToken, ^{
        viewControllersArray = [NSMutableArray array];
    });
    
    BOOL foundAndSet = NO;
    for (int i = viewControllersArray.count-1; i>=0; i--)
    {
        __WeakWrapper* wrapper = viewControllersArray[i];
        if(wrapper.viewController == nil ||
           wrapper.card == nil)
        {
            [viewControllersArray removeObjectAtIndex:i];
        }
        else
        {
            if(wrapper.card == self)
            {
                foundAndSet = YES;
                wrapper.viewController = viewController;
            }
        }
    }
    
    if(!foundAndSet)
    {
        __WeakWrapper* wrapper = [__WeakWrapper new];
        wrapper.viewController = viewController;
        wrapper.card = self;
        [viewControllersArray addObject:wrapper];
    }
    
}

@end
