//
//  RequestTracker.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "RequestTracker.h"

@implementation RequestTracker

- (id)initWithDelegate:(id<RequestTrackerDelegate>)delegate;
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
    }
    return self;
}

@end
