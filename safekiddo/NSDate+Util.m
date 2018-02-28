//
//  NSDate+Util.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 24.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NSDate+Util.h"

@implementation NSDate (Util)

-(NSDate*)dateOnly
{
    unsigned int flags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* components = [calendar components:flags fromDate:self];
    return [calendar dateFromComponents:components];
}

-(NSString *)dayString
{
    static dispatch_once_t onceToken;
    static NSDateFormatter* dateFormatter;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    });
    return [dateFormatter stringFromDate:self];
}

@end
