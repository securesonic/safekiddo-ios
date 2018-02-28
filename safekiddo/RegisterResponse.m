//
//  RegisterResponse.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "RegisterResponse.h"

@implementation RegisterResponse

+(JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
