//
//  SafeSearchURL.m
//  safekiddo
//
//  Created by Jakub Długosz on 17.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "SafeSearchURL.h"

@implementation SafeSearchURL

-(NSString *)enforceSafeSearch:(NSString *)inputSearchQuery
{
    inputSearchQuery = [inputSearchQuery stringByReplacingOccurrencesOfString:self.parameter withString:@""];
    inputSearchQuery = [inputSearchQuery stringByReplacingOccurrencesOfString:@"&&" withString:@"&"];
    inputSearchQuery = [inputSearchQuery stringByReplacingOccurrencesOfString:@"?&" withString:@"?"];
    
    return [inputSearchQuery stringByAppendingFormat:@"&%@",self.parameter];
}


@end
