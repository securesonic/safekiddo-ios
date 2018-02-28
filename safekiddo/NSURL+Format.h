//
//  NSURL+Format.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 23.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Format)

-(NSString*)displayString;
+(NSURL*)URLFromDisplayString:(NSString*)string;
@end
