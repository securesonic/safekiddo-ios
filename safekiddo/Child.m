//
//  Child.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Child.h"

@implementation Child

+(JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
