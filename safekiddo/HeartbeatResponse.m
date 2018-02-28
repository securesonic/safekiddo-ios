//
//  HeartbeatResponse.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "HeartbeatResponse.h"

@implementation HeartbeatResponse 

+(JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

@end
