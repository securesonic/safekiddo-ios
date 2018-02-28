//
//  TabBrowserTransitioning.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "TabBrowserTransitioning.h"
#import "TabBrowserAnimatedTransitioning.h"
@implementation TabBrowserTransitioning

-(id)initWithRectOfOriginCell:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        _rectOfOriginCell = rect;
    }
    return self;
}

#pragma mark - UIViewControllerTransitioningDelegate -

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[TabBrowserAnimatedTransitioning alloc]initWithReverse:NO lastKnownCellRect:self.rectOfOriginCell];
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[TabBrowserAnimatedTransitioning alloc]initWithReverse:YES lastKnownCellRect:self.rectOfOriginCell];
}

@end
