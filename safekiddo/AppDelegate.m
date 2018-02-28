//
//  AppDelegate.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 03.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "AppDelegate.h"
#import "ProfileInstaller.h"
#import "Utilities.h"
#import "WelcomeViewController.h"
#import "HTTPServerUttilities.h"
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import "SafeURLProtocol.h"
#import "CoreData.h"
#import "BookmarkFolder.h"
#import "Appearance.h"
#import "NetworkLogger.h"
#import "Constants.h"
#import <SplunkMint-iOS/SplunkMint-iOS.h>
#import "URLParser.h"
#import "NetworkManager+Children.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "Utilities.h"
#import "NetworkSessionManager.h"
#import <HockeySDK/HockeySDK.h>
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@interface AppDelegate ()

@property(assign,nonatomic)BOOL notificatonLoop;

-(void)handleApplicationRestart:(NSNotification*)notification;

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if([url.absoluteString containsString:@"selectChild"])
    {
        URLParser* parser = [[URLParser alloc]initWithURLString:url.absoluteString];
        NSString* uuid = [parser valueForVariable:kUUIDParameter];
        NSString* childName = [parser valueForVariable:kChildNameParameter];
        
        [MBProgressHUD showHUDAddedTo:self.window.rootViewController.view animated:YES];
        [NetworkManager pairDevice:[Utilities uuid]
                         withChild:uuid
                   usingDeviceName:[Utilities deviceName]
                  withSuccessBlock:^(PairChildResponse* response)
         {
             [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
             if(response.success.boolValue)
             {
                 [Utilities storeChildUUID:uuid];
                 [Utilities storeChildName:childName];
             }
         }
                      failureBlock:^(NSError * error)
         {
             [MBProgressHUD hideHUDForView:self.window.rootViewController.view animated:YES];
         }];
    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [Fabric with:@[CrashlyticsKit]];

    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"b48f1bcfd9ee84166c73cd963f584073"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    
    [[Mint sharedInstance] initAndStartSession:@"71c24d5f"];
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    DDFileLogger* fileLogger = [[DDFileLogger alloc] init];
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    
    [DDLog addLogger:fileLogger];
    [[NetworkLogger sharedLogger]start];
    [Appearance setupAppearance];
    
    
    
    
    DDLogInfo(@"%@",@"==========");
    DDLogInfo(@"%@",@"Application start");
    DDLogInfo(@"%@",@"==========");
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(handleApplicationRestart:) name:kRestartApplicationNotification object:nil];
    
    if([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        [[UIApplication sharedApplication] registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound| UIUserNotificationTypeAlert categories:nil]];
    }

    
    [NSURLProtocol registerClass:[SafeURLProtocol class]];
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
#if defined(DEV) || defined(TEST)
   // [[AFNetworkActivityLogger sharedLogger]startLogging];
    safeURLProtocolDebugMode = NO;
  //  [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelDebug];
    
#endif
    
    if([[ProfileInstaller sharedInstaller]isProfileInstalled])
    {
        UIViewController* controller = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateViewControllerWithIdentifier:@"Loading"];
        self.window.rootViewController = controller;
        
        
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
        #warning TODO: trzeba obsłużyć wygaśnięcie sesji. np.
        [[NetworkSessionManager sharedManager] applicationStartWithCompletionBlock:^
        {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Browser" bundle:nil]instantiateInitialViewController];
        }];
    }
    else
    {
        [[CoreDataManager sharedInstance]purge];
        [Utilities storePassword:nil];
        self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateInitialViewController];
    }
    
    [self.window makeKeyAndVisible];
    
    if(launchOptions[UIApplicationLaunchOptionsURLKey] &&
       [[launchOptions[UIApplicationLaunchOptionsURLKey] absoluteString] rangeOfString:@"settings"].location != NSNotFound)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:kOpenSettingsNotification object:nil];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//UIBackgroundTaskIdentifier bgTask;

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    
     if(![[ProfileInstaller sharedInstaller]isProfileInstalled])
     {
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
             self.notificatonLoop = YES;
             
             while (self.notificatonLoop)
             {
                 [NSThread sleepForTimeInterval:1];
                 self.notificatonLoop = ![[ProfileInstaller sharedInstaller]isProfileInstalled];
             }
             
             UILocalNotification* notification = [[UILocalNotification alloc]init];
             notification.fireDate = [NSDate date];
             notification.alertBody = NSLocalizedString(@"USER_NOTIFICATION", @"");
             notification.alertAction = nil;
             notification.soundName = UILocalNotificationDefaultSoundName;
           
             [[UIApplication sharedApplication] scheduleLocalNotification:notification];
         });
     }

    
    [application beginBackgroundTaskWithExpirationHandler:^{
    
    }];
/*
 
 
         NSAssert(bgTask == UIBackgroundTaskInvalid, nil);
        
        bgTask = [application beginBackgroundTaskWithExpirationHandler: ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [application endBackgroundTask:bgTask];
                bgTask = UIBackgroundTaskInvalid;
            });
        }];
    }];
 */
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    self.notificatonLoop = NO;
    
    if([[ProfileInstaller sharedInstaller]isProfileInstalled] && [Utilities isLoggedIn])
    {
        [[UIApplication sharedApplication]registerForRemoteNotifications];
        
        if(self.window.rootViewController.class == [WelcomeViewController class])
        {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Browser" bundle:nil]instantiateInitialViewController];
            [HTTPServerUttilities stopServer];
        }
    }
    else
    {
        if([Utilities isLoggedIn])
        {
            [[CoreDataManager sharedInstance]purge];
        }
        [Utilities storePassword:nil];
        if(self.window.rootViewController.class != [WelcomeViewController class])
        {
            self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Welcome" bundle:nil]instantiateInitialViewController];
        }
    }
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)handleApplicationRestart:(NSNotification*)notification
{
    [self applicationWillEnterForeground:[UIApplication sharedApplication]];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[NetworkSessionManager sharedManager] registerAPNSToken:deviceToken];
}

@end
