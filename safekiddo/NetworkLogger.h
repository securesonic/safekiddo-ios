//
//  NetworkLogger.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 27.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkLogger : NSObject

+(NetworkLogger*)sharedLogger;

-(void)start;
-(void)stop;

@end
