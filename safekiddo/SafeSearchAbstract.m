//
//  SafeSearchRegex.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "SafeSearchAbstract.h"

@implementation SafeSearchAbstract

-(BOOL)regexMatch:(NSURL*)query
{
    if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.regexHost] evaluateWithObject:query.host])
    {
        if([[NSPredicate predicateWithFormat:@"SELF MATCHES %@",self.regexFile] evaluateWithObject:query.path])
        {
            return YES;
        }
    }

    return NO;
}

-(NSString*)enforceSafeSearch:(NSString*)inputSearchQuery
{
    @throw @"Implement in child class";
}

@end
