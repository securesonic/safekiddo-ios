//
//  RequestTracker.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RequestTracker;

@protocol RequestTrackerDelegate <NSObject>

@optional
-(void)requestTrackerDidStartParentalControl:(RequestTracker*)tracker;
-(void)requestTrackerDidEndParentalControl:(RequestTracker *)tracker;

-(void)requestTrackerDidEndPageLoad:(RequestTracker*)tracker;




@end

@interface RequestTracker : NSObject

@property(weak,nonatomic)id<RequestTrackerDelegate> delegate;

-(id)initWithDelegate:(id<RequestTrackerDelegate>)delegate;

@end

