//
//  Settings.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 17.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Settings.h"

static Settings* _settings;

NSString* const kUseMobileUserAgentKey = @"kUseMobileUserAgentKey";

@implementation Settings

+(Settings*)sharedSettings
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _settings = [Settings new];
        [_settings loadSettings];
    });
    
    return _settings;
}

#pragma mark - Properties -

-(void)setUseMobileUserAgent:(BOOL)useMobileUserAgent
{
    _useMobileUserAgent = useMobileUserAgent;
    [self saveSettings];
}

#pragma mark - Private -

-(void)loadSettings
{
    self.useMobileUserAgent = [[NSUserDefaults standardUserDefaults]objectForKey:kUseMobileUserAgentKey]?
    [[NSUserDefaults standardUserDefaults]boolForKey:kUseMobileUserAgentKey]: YES;
    
}

-(void)saveSettings
{
    [[NSUserDefaults standardUserDefaults]setBool:self.useMobileUserAgent forKey:kUseMobileUserAgentKey];
    
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
}

@end
