//
//  HeartbeatResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
@interface HeartbeatResponse : Response

@property(strong,nonatomic)NSNumber<Optional>* heartbeatInterval;
@property(strong,nonatomic)NSNumber<Optional>* blockAccess;

@end
