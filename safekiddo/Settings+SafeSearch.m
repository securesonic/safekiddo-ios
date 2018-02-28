//
//  Settings+SafeSearch.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "Settings+SafeSearch.h"
#import "SafeSearchCookie.h"
#import "SafeSearchURL.h"
NSString* const kSearchEngineKey = @"kSearchEngineKey";

NSString* StringFromSettingsEngine(SearchEngine engine)
{
    switch (engine)
    {
        case SearchEngineBing:
            return @"Bing";
        case SearchEngineGoogle:
            return @"Google";
        case SearchEngineYahoo:
            return @"Yahoo";
        case SearchEngineYoutube:
            return @"Youtube";
    }
}

NSString* SearchFormatFromSettingsEngine(SearchEngine engine)
{
    switch (engine)
    {
        case SearchEngineBing:
            return @"http://www.bing.com/search?q=%@&adlt=strict";
            break;
        case SearchEngineGoogle:
            return @"https://www.google.com/search?q=%@&safe=active";
            break;
        case SearchEngineYahoo:
            return @"https://search.yahoo.com/search?p=%@&vm=r";
            break;
        case SearchEngineYoutube:
            return @"https://www.youtube.com/results?search_query=%@";
    }
}

@implementation Settings (SafeSearch)

-(SearchEngine)searchEngine
{
    return [[[NSUserDefaults standardUserDefaults]objectForKey:kSearchEngineKey] intValue];
}

-(void)setSearchEngine:(SearchEngine)searchEngine
{
    [[NSUserDefaults standardUserDefaults]setObject:@(searchEngine) forKey:kSearchEngineKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(SafeSearchAbstract*)safeSearchRegexForEngine:(SearchEngine)engine
{
    SafeSearchAbstract* regex;
    switch (engine)
    {
        case SearchEngineBing:
            regex = [SafeSearchURL new];
            regex.regexHost = @".*\\.bing\\..*";
            regex.regexFile = @"\\/search";
            ((SafeSearchURL*)regex).parameter = @"adlt=strict";
            ((SafeSearchURL*)regex).negativeParameter = @"adlt=strict";
            break;
        case SearchEngineGoogle:
            regex = [SafeSearchURL new];
            regex.regexHost = @".*\\.google\\..*";
            regex.regexFile = @"^/(custom|search|images)\?";
            ((SafeSearchURL*)regex).parameter = @"safe=active";
            ((SafeSearchURL*)regex).negativeParameter = @"adlt=strict";
            break;
        case SearchEngineYahoo:
            regex = [SafeSearchURL new];
            regex.regexHost = @".*\\.yahoo\\..*";
            regex.regexFile = @"^/search";
            ((SafeSearchURL*)regex).parameter = @"vm=r";
            ((SafeSearchURL*)regex).negativeParameter = @"adlt=strict";
            break;
        case SearchEngineYoutube:
        {
            regex = [SafeSearchCookie new];
            regex.regexHost = @".*\\.youtube\\..*";
            regex.regexFile = @".*";
            ((SafeSearchCookie*)regex).cookieName = @"PREF";
            ((SafeSearchCookie*)regex).domainName = @"youtube";
            ((SafeSearchCookie*)regex).cookieParameterName = @"f2";
            ((SafeSearchCookie*)regex).cookieParameterValue = @"8000000";
            
        }

    }
    
    return regex;
}

static NSArray* _arrayOsSearchRegex;

-(NSArray*)arrayOfSearchRegex
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _arrayOsSearchRegex = @[[self safeSearchRegexForEngine:SearchEngineGoogle],[self safeSearchRegexForEngine:SearchEngineBing],[self safeSearchRegexForEngine:SearchEngineYahoo],[self safeSearchRegexForEngine:SearchEngineYoutube]];
    });
    return _arrayOsSearchRegex;
}



@end
