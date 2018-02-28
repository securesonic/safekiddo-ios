//
//  TabBrowserAnimatedTransitioning.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBrowserAnimatedTransitioning : NSObject<UIViewControllerAnimatedTransitioning>

-(id)initWithReverse:(BOOL)isReverse lastKnownCellRect:(CGRect)rect;

@property(assign,nonatomic)BOOL isReverse;
@property(assign,nonatomic)CGRect rect;

@end
