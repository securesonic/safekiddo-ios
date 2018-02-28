//
//  SafeSearchRegex.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SafeSearchAbstract : NSObject

@property(strong,nonatomic)NSString* regexHost;
@property(strong,nonatomic)NSString* regexFile;

-(BOOL)regexMatch:(NSURL*)query;
-(NSString*)enforceSafeSearch:(NSString*)inputSearchQuery;


@end
