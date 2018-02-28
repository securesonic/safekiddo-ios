//
//  TabBrowserAnimatedTransitioning.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "TabBrowserAnimatedTransitioning.h"

NSTimeInterval const kAnimationDuration = 0.3;

@implementation TabBrowserAnimatedTransitioning

-(id)initWithReverse:(BOOL)isReverse lastKnownCellRect:(CGRect)rect
{
    self = [super init];
    if(self)
    {
        _isReverse = isReverse;
        _rect = rect;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return kAnimationDuration;
}



- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView* fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView* toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *container = [transitionContext containerView];
    
    if(self.isReverse)
    {
        [container insertSubview:toView belowSubview:fromView];
    }
    else
    {
        toView.transform = CGAffineTransformIdentity;
        toView.frame = container.frame;
        
        [container addSubview:toView];
        
        float scaleWidth = _rect.size.width / toView.frame.size.width;
        float scaleHeight = _rect.size.height / toView.frame.size.height;
        
        float scaleToUse = MIN(scaleHeight,scaleWidth);
        
        toView.transform = CGAffineTransformMakeScale(scaleToUse, scaleToUse);
        toView.transform = CGAffineTransformTranslate(toView.transform, (-toView.frame.origin.x + _rect.origin.x) / scaleToUse, (-toView.frame.origin.y + _rect.origin.y) / scaleToUse);
       // toView.alpha=0.f;
    }

    [UIView animateWithDuration:kAnimationDuration delay:0.f options:UIViewAnimationOptionCurveEaseOut animations:^{
        if(self.isReverse)
        {
            float scaleWidth = _rect.size.width / fromView.frame.size.width;
            float scaleHeight = _rect.size.height / fromView.frame.size.height;

            float scaleToUse = MIN(scaleHeight,scaleWidth);
            
            fromView.transform = CGAffineTransformMakeScale(scaleToUse, scaleToUse);
            fromView.transform = CGAffineTransformTranslate(fromView.transform, (-fromView.frame.origin.x + _rect.origin.x) / scaleToUse, (-fromView.frame.origin.y + _rect.origin.y) / scaleToUse);
          //  fromView.alpha = 0.f;
        }
        else
        {
            toView.transform = CGAffineTransformIdentity;
           // toView.alpha = 1.f;
        }
    }  completion:^(BOOL finished) {
          [transitionContext completeTransition:finished];
    }];
}

@end
