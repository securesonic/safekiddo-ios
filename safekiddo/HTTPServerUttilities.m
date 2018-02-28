//
//  HTTPServerUttilities.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 14.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "HTTPServerUttilities.h"
#import "Utilities.h"
#import <RoutingHTTPServer/RoutingHTTPServer.h>

static RoutingHTTPServer* httpServer;

#define kServerPort 1234
#define kServerDocumentsFolder @"HTTPRoot"

@interface HTTPServerUttilities()

/**
 *  @return Path to HTTP documents folder
 */
+(NSString*)httpDocumentsRoot;

@end

@implementation HTTPServerUttilities

#pragma mark - Public -

+(void)startServer
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpServer = [[RoutingHTTPServer alloc]init];
        [httpServer setPort:kServerPort];
        [httpServer setDocumentRoot:[self httpDocumentsRoot]];
        [httpServer setDefaultHeader:@"Content-Type" value:@"application/x-apple-aspen-config"];
        
    });
   
    if(!httpServer.isRunning)
    {
        NSError* error;
        [httpServer start:&error];
        if(error)
        {
            NSLog(@"%@",error);
        }
    }
    
    
}
+(void)stopServer
{
    if(httpServer.isRunning)
    {
        [httpServer stop];
    }
}

+(void)storeFile:(NSData*)fileData named:(NSString*)fileName
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[self httpDocumentsRoot]])
    {
        NSError* error;
        [[NSFileManager defaultManager] createDirectoryAtPath:[self httpDocumentsRoot] withIntermediateDirectories:YES attributes:nil error:&error];
        
        if(error)
        {
            NSLog(@"%@",error);
        }
    }

   if(![fileData writeToFile:[[self httpDocumentsRoot] stringByAppendingPathComponent:fileName] atomically:YES])
   {
       NSLog(@"%@ %@",@"Unable to store file: ",fileName);
   }
}

+(void)openFileInSafari:(NSString*)fileName
{
    NSString* path = [NSString stringWithFormat:@"http://localhost:%d/%@",kServerPort,fileName];
    
    if([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:path]])
    {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:path]];
    }
}

#pragma mark - Private -

+(NSString*)httpDocumentsRoot
{
    return [[Utilities documentsFolderPath] stringByAppendingPathComponent:kServerDocumentsFolder];
}



@end
