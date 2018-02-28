//
//  Utilities.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 03.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  A Utilities helper class
 */
@interface Utilities : NSObject

/**
 *  Method generates current path to documents folder
 *
 *  @return A NSString with a current path to docuements folder
 */
+(NSString*)documentsFolderPath;

/**
 *  An url to account creation on web page
 */
FOUNDATION_EXPORT NSString* const kCreateAccountAddress;

#define IS_WIDESCREEN_IOS7 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_WIDESCREEN_IOS8 ( fabs( ( double )[ [ UIScreen mainScreen ] nativeBounds ].size.height - ( double )1136 ) < DBL_EPSILON )
#define IS_WIDESCREEN      ( ( [ [ UIScreen mainScreen ] respondsToSelector: @selector( nativeBounds ) ] ) ? IS_WIDESCREEN_IOS8 : IS_WIDESCREEN_IOS7 )


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)


/**
 *  Saves profile pin in keychain
 *
 *  @param pin pin to be saved
 */
+(void)storeProfilePin:(NSString*)pin;
/**
 *  Retrieves profile pin from keychain
 *
 *  @return stored pin
 */
+(NSString*)retrieveProfilePin;


/**
 *  Saves pin in keychain
 *
 *  @param pin pin to be saved
 */
+(void)storePin:(NSString*)pin;
/**
 *  Retrieves pin from keychain
 *
 *  @return stored pin
 */
+(NSString*)retrievePin;

+(void)storePassword:(NSString*)password;
+(void)storeUsername:(NSString*)username;

+(NSString*)retrievePassword;
+(NSString*)retrieveUsername;

+(void)storeChildUUID:(NSString*)uuid;
+(NSString*)retrieveChildUUID;

+(void)storeChildName:(NSString*)childName;
+(NSString*)childName;

+(void)storeHeartBeat:(NSDate*)heartBeat;
+(NSDate*)retrieveHeartBeat;

+(BOOL)isLoggedIn;

/**
 *  Calculates an application UUID
 *
 *  @return NSString uuid value
 */
+(NSString*)uuid;

/**
 *  Returns device name
 *
 *  @return NSString device name
 */
+(NSString*)deviceName;

/**
 *  User-Agent header used by desktop browsers
 *
 *  @return string sent by desktop safari in a header
 */
+(NSString*)desktopUserAgent;

+(NSString*)urlRegex;

+(NSString*)acceptLangugage;

@end
