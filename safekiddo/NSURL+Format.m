//
//  NSURL+Format.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 23.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NSURL+Format.h"
#import "Utilities.h"
@implementation NSURL (Format)

-(NSString*)displayString
{
    NSString* scheme = [self scheme];
    if([scheme isEqualToString:@"applewebdata"])
    {
        return nil;
    }
    else
    {
        return  [self absoluteString];
    }
}

+(NSURL*)URLFromDisplayString:(NSString*)string
{
    
    NSURL* candidateURL = [NSURL URLWithString:string];
    
    if(candidateURL && candidateURL.scheme && candidateURL.host)
    {
        return candidateURL;
    }
    else
    {
        // double test using regex
        
        NSString *urlRegEx = [Utilities urlRegex];
        NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
        
        
        BOOL isURL = [urlTest evaluateWithObject:string];
        
        if(!isURL)
        {
            isURL = [urlTest evaluateWithObject:[NSString stringWithFormat:@"http://%@",string]];
        }
        
        if(!isURL)
        {
            return nil;
        }
        else
        {
            NSURL* url = [NSURL URLWithString:string];
            if(url.resourceSpecifier)
            {
                url =[NSURL URLWithString:[NSString stringWithFormat:@"http://%@",url.resourceSpecifier]];
                return url;
            }
            else
            {
                return nil;
            }
        }
    }
}
@end
