//
//  ParentalControlResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    NoChildProfile =-2,
    Empty = -1,
    Success = 0,
    InternetAccessForbidden = 100,
    CategoryBlockedCustom = 111,
    CategoryBlockedGlobal = 112,
    UrlBlockedCustom = 121,
    UrlBlockedGlobal = 122,
    IpReputationCheckFailed = 200,
    UnknownUser = 300
}ParentalControlResponseEnum;

@interface ParentalControlResponse : NSObject

@property(strong,nonatomic)NSString* result;
@property(strong,nonatomic)NSString* usedProfileId;
@property(strong,nonatomic)NSString* usedProfileName;
@property(strong,nonatomic)NSString* categoryGroupId;
@property(strong,nonatomic)NSString* categoryGroupName;


@end
