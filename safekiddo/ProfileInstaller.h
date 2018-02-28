//
//  ProfileInstaller.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class manages profiles installed by an application
 */
@interface ProfileInstaller : NSObject

/**
 *  A shared instance to a ProfileInstaller
 *
 *  @return An instance of a ProfileInstaller class
 */
+(ProfileInstaller*)sharedInstaller;

/**
 *  Method returns if a profile is installed. It uses a certificate stored in Application Bundle, to check it against a certificate stored in Configuration Profile
 *
 *  @return Flag indicating if the profile is installed.
 */
-(BOOL)isProfileInstalled;

/**
 *  Installs a profile, using a pin to secure it.
 *
 *  @param pin Pin needed to uninstall a profile
 */
-(void)installProfileWithPin:(NSString*)pin;

/**
 *  Unistalls secure profile - installs a new empty one to overide the restrictions
 */
-(void)uninstallProfile;


@end
