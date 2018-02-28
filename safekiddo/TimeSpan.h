//
//  TimeSpan.h
//  safekiddo
//
//  Created by Jakub Długosz on 12.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeSpan : NSObject

-(NSDictionary*)toDictionary;


+(TimeSpan*)timeSpaneWithStartDate:(NSDate*)startDate endDate:(NSDate*)endDate;

@property(strong,nonatomic)NSString* startTime;
@property(strong,nonatomic)NSString* endTime;
@property(assign,nonatomic)int duration;

@end
