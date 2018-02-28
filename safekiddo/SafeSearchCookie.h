//
//  SafeSearchCookie.h
//  safekiddo
//
//  Created by Jakub Długosz on 17.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SafeSearchAbstract.h"
@interface SafeSearchCookie : SafeSearchAbstract

@property(strong,nonatomic) NSString* cookieName;
@property(strong,nonatomic) NSString* domainName;
@property(strong,nonatomic) NSString* cookieParameterName;
@property(strong,nonatomic) NSString* cookieParameterValue;

@end
