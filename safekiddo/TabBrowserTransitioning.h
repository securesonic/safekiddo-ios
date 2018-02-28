//
//  TabBrowserTransitioning.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBrowserTransitioning : NSObject<UIViewControllerTransitioningDelegate>

-(id)initWithRectOfOriginCell:(CGRect)rect;

@property (assign,nonatomic) CGRect rectOfOriginCell;

@end
