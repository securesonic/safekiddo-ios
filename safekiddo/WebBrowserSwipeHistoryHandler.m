//
//  WebBrowserSwipeHistoryHandler.m
//  safekiddo
//
//  Created by Jakub Długosz on 13.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "WebBrowserSwipeHistoryHandler.h"
#import "UImageStack.h"
@interface WebBrowserSwipeHistoryHandler()<UIGestureRecognizerDelegate>

@property(weak,nonatomic)UIWebView* webView;
@property(weak,nonatomic)NSLayoutConstraint* leadingLayoutContraint;
@property(strong,nonatomic)NSLayoutConstraint* leadingSnapshotConstraint;

@property(strong,nonatomic)UIImageView* snapshotImageView;

@property(strong,nonatomic)UIScreenEdgePanGestureRecognizer* leftEdgeGesture;
@property(strong,nonatomic)UIScreenEdgePanGestureRecognizer* rightEdgeGesture;


-(void)leftEdgeScreenPanGestureAction:(UIScreenEdgePanGestureRecognizer*)sender;
-(void)rightEdgeScreenPanGestureAction:(UIScreenEdgePanGestureRecognizer*)sender;

-(UIImage*)takeSnapShot;

@property(strong,nonatomic)UImageStack* imageStack;

@end

#define kPercentOfView 50.f

@implementation WebBrowserSwipeHistoryHandler

-(id)initWithWebView:(UIWebView*)webView leadingLayoutConstraint:(NSLayoutConstraint *)constraint
{
    self = [super init];
    if(self)
    {
        self.imageStack = [UImageStack new];
        self.webView = webView;
        self.leadingLayoutContraint = constraint;
        
        self.leftEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(leftEdgeScreenPanGestureAction:)];
        self.leftEdgeGesture.edges = UIRectEdgeLeft ;
        self.leftEdgeGesture.delegate = self;
        
        self.rightEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(rightEdgeScreenPanGestureAction:)];
        self.rightEdgeGesture.edges = UIRectEdgeRight ;
        self.rightEdgeGesture.delegate = self;
        
        
        [self.webView addGestureRecognizer:self.leftEdgeGesture];
        [self.webView addGestureRecognizer:self.rightEdgeGesture];
        
        
    }
    
    return self;
}

#pragma mark - Private -

-(UIImage*)takeSnapShot
{
    UIGraphicsBeginImageContextWithOptions(self.webView.bounds.size, NO, 0);
    [self.webView drawViewHierarchyInRect:self.webView.bounds afterScreenUpdates:YES];
    UIImage *copied = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return copied;
}

#pragma mark - Public - 

-(void)webviewWillNavigateBack
{
    UIImage* snapshot = [self takeSnapShot];
    [self.imageStack moveBackInStack:snapshot];
}

-(void)webviewWillNavigateForward
{
    UIImage* snapshot = [self takeSnapShot];
    [self.imageStack moveForwardIntStack:snapshot];
}

-(void)webviewWillNavigateNew
{
    UIImage* snapshot = [self takeSnapShot];
    [self.imageStack pushToStack:snapshot];
}

-(void)webviewLoaded
{
    [self.snapshotImageView removeFromSuperview];
    self.snapshotImageView = nil;
}

#pragma mark - Private -

-(void)leftEdgeScreenPanGestureAction:(UIScreenEdgePanGestureRecognizer*)sender
{
    if(self.webView.canGoBack)
    {
        if(sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
        {
            if(self.snapshotImageView)
            {
                [self.snapshotImageView removeFromSuperview];
                self.snapshotImageView = nil;
            }
            
            UIImage* image = [self.imageStack getBackImage];
            
            self.snapshotImageView = [[UIImageView alloc] initWithImage:image];
            
            self.snapshotImageView.translatesAutoresizingMaskIntoConstraints = NO;
        
            
            [self.webView.superview insertSubview:self.snapshotImageView belowSubview:self.webView];
            
            self.leadingSnapshotConstraint = [NSLayoutConstraint constraintWithItem:self.webView.superview
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.snapshotImageView
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
            
            [self.webView.superview addConstraints:
             @[
            self.leadingSnapshotConstraint,
            [NSLayoutConstraint constraintWithItem:self.webView
                                         attribute:NSLayoutAttributeTop
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.snapshotImageView
                                         attribute:NSLayoutAttributeTop
                                        multiplier:1
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.webView
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.snapshotImageView
                                         attribute:NSLayoutAttributeWidth
                                        multiplier:1
                                          constant:0],
            [NSLayoutConstraint constraintWithItem:self.webView
                                         attribute:NSLayoutAttributeHeight
                                         relatedBy:NSLayoutRelationEqual
                                            toItem:self.snapshotImageView
                                         attribute:NSLayoutAttributeHeight
                                        multiplier:1
                                          constant:0]
            ]];
            
        
            
            self.webView.scrollView.scrollEnabled = NO;
            CGPoint translation = [sender translationInView:sender.view];
            
            self.leadingLayoutContraint.constant = translation.x;
            self.leadingSnapshotConstraint.constant = (kPercentOfView/100.f) * (self.webView.frame.size.width - translation.x);
        }else
        {
            self.webView.scrollView.scrollEnabled = YES;
            CGPoint translation = [sender translationInView:sender.view];
            NSLog(@"Translation %@",NSStringFromCGPoint(translation));
            if(abs(translation.x) > self.webView.superview.frame.size.width / 2)
            {
                [self.webView.superview layoutIfNeeded];
                self.leadingLayoutContraint.constant = self.webView.frame.size.width;
                self.leadingSnapshotConstraint.constant = 0;
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.webView.superview layoutIfNeeded];
                } completion:^(BOOL finished)
                {
                    UIImage* snapshot = [self takeSnapShot];
                    [self.imageStack moveBackInStack:snapshot];
                    
                    self.leadingLayoutContraint.constant = 0;
                    [self.webView.superview layoutIfNeeded];
                    [self.webView goBack]; // deals with it - autolayout
                    
                    [self.webView.superview bringSubviewToFront:self.snapshotImageView];
                }];
            }
            else
            {
                self.leadingLayoutContraint.constant = 0;
                [UIView animateWithDuration:1.0 animations:^{
                    [self.webView.superview layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [self.snapshotImageView removeFromSuperview];
                    self.snapshotImageView = nil;
                }];
            }
        }
    }
}


-(void)rightEdgeScreenPanGestureAction:(UIScreenEdgePanGestureRecognizer*)sender
{
    if([self.webView canGoForward])
    {
        if(sender.state == UIGestureRecognizerStateBegan || sender.state == UIGestureRecognizerStateChanged)
        {
            if(self.snapshotImageView)
            {
                [self.snapshotImageView removeFromSuperview];
                self.snapshotImageView = nil;
            }
            
            UIImage* image = [self.imageStack getForwardImage];
            self.snapshotImageView = [[UIImageView alloc] initWithImage:image];
            self.snapshotImageView.translatesAutoresizingMaskIntoConstraints = NO;
            [self.webView.superview insertSubview:self.snapshotImageView belowSubview:self.webView];

            
            self.leadingSnapshotConstraint = [NSLayoutConstraint constraintWithItem:self.webView.superview
                                                                          attribute:NSLayoutAttributeLeading
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.snapshotImageView
                                                                          attribute:NSLayoutAttributeLeading
                                                                         multiplier:1
                                                                           constant:0];
            
            [self.webView.superview addConstraints:
             @[
               self.leadingSnapshotConstraint,
               [NSLayoutConstraint constraintWithItem:self.webView
                                            attribute:NSLayoutAttributeTop
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.snapshotImageView
                                            attribute:NSLayoutAttributeTop
                                           multiplier:1
                                             constant:0],
               [NSLayoutConstraint constraintWithItem:self.webView
                                            attribute:NSLayoutAttributeWidth
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.snapshotImageView
                                            attribute:NSLayoutAttributeWidth
                                           multiplier:1
                                             constant:0],
               [NSLayoutConstraint constraintWithItem:self.webView
                                            attribute:NSLayoutAttributeHeight
                                            relatedBy:NSLayoutRelationEqual
                                               toItem:self.snapshotImageView
                                            attribute:NSLayoutAttributeHeight
                                           multiplier:1
                                             constant:0]
               ]];
            
            
            
            self.webView.scrollView.scrollEnabled = NO;
            CGPoint translation = [sender translationInView:sender.view];
            
            self.leadingLayoutContraint.constant = translation.x;
            self.leadingSnapshotConstraint.constant = -(kPercentOfView/100.f) * (self.webView.frame.size.width + translation.x);
 
        }else
        {
            self.webView.scrollView.scrollEnabled = YES;
            CGPoint translation = [sender translationInView:sender.view];
            NSLog(@"Translation %@",NSStringFromCGPoint(translation));
            if(abs(translation.x) > self.webView.superview.frame.size.width / 2)
            {
                [self.webView.superview layoutIfNeeded];
                self.leadingLayoutContraint.constant = -self.webView.frame.size.width;
                self.leadingSnapshotConstraint.constant = 0;
                
                [UIView animateWithDuration:0.2 animations:^{
                    [self.webView.superview layoutIfNeeded];
                } completion:^(BOOL finished)
                 {
                     UIImage* snapshot = [self takeSnapShot];
                     [self.imageStack moveForwardIntStack:snapshot];
                     
                     self.leadingLayoutContraint.constant = 0;
                     [self.webView.superview layoutIfNeeded];
                     [self.webView goForward]; // deals with it - autolayout
                     
                     [self.webView.superview bringSubviewToFront:self.snapshotImageView];
                 }];
            }
            else
            {
                self.leadingLayoutContraint.constant = 0;
                [UIView animateWithDuration:0.2 animations:^{
                    [self.webView.superview layoutIfNeeded];
                } completion:^(BOOL finished) {
                    [self.snapshotImageView removeFromSuperview];
                    self.snapshotImageView = nil;
                }];
            }

        }
    }
}

#pragma mark - UIGestureRecognizerDelegate -

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end
