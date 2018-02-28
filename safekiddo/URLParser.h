//
//  URLParser.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 10.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLParser : NSObject {
    NSArray *variables;
}

@property (nonatomic, retain) NSArray *variables;

- (id)initWithURLString:(NSString *)url;
- (NSString *)valueForVariable:(NSString *)varName;

@end