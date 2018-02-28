//
//  HTTPServerUttilities.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class responsible for HTTP server operations
 */
@interface HTTPServerUttilities : NSObject

/**
 *  Starts a HTTP server
 */
+(void)startServer;
/**
 *  Stops a HTTP server
 */
+(void)stopServer;

/**
 *  Saves a file in HTTP server's document folder
 *
 *  @param fileData NSData object to save
 *  @param fileName Name of a file to save
 */
+(void)storeFile:(NSData*)fileData named:(NSString*)fileName;

/**
 *  Calls Safari browser to open a given filename. The file has to be stored first.
 *
 *  @param fileName Name of a file to open.
 */
+(void)openFileInSafari:(NSString*)fileName;
@end
