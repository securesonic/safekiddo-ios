//
//  PairChildResponse.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "PairChildResponse.h"

@implementation PairChildResponse

+(JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
