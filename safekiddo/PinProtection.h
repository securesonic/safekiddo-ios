//
//  PinProtection.h
//  safekiddo
//
//  Created by Jakub Długosz on 30.01.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinProtection : NSObject

+(PinProtection*)sharedPinProtection;

@property(assign,nonatomic)int triesLeft;

@property(strong,nonatomic)NSDate* timeOutDate;

FOUNDATION_EXPORT int const kPINProtectionMaxTriesLeft;
FOUNDATION_EXPORT int const kPINProtectionTimeoutSeconds;

@end
