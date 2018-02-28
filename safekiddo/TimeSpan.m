//
//  TimeSpan.m
//  safekiddo
//
//  Created by Jakub Długosz on 12.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "TimeSpan.h"

static NSDateFormatter* _dateFormatter;

@implementation TimeSpan

-(NSDictionary*)toDictionary
{
    return @{@"start_time":self.startTime,
             @"end_time":self.endTime,
             @"duration":@(self.duration).stringValue};
}

+(TimeSpan*)timeSpaneWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateFormat:@"HH:mm:00"];
    });
    
    TimeSpan* ts = [TimeSpan new];
    
    ts.startTime = [_dateFormatter stringFromDate:startDate];
    ts.endTime = [_dateFormatter stringFromDate:endDate];
    
    ts.duration = [endDate timeIntervalSinceDate:startDate];
    
    return ts;
}

@end
