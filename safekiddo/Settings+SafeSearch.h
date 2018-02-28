//
//  Settings+SafeSearch.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 01.02.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "Settings.h"
#import "SafeSearchAbstract.h"
typedef enum
{
    SearchEngineGoogle,
    SearchEngineBing,
    SearchEngineYahoo,
    SearchEngineYoutube
}SearchEngine;

FOUNDATION_EXPORT NSString* StringFromSettingsEngine(SearchEngine engine);
FOUNDATION_EXPORT NSString* SearchFormatFromSettingsEngine(SearchEngine engine);
@interface Settings (SafeSearch)

@property(assign,nonatomic)SearchEngine searchEngine;

-(SafeSearchAbstract*)safeSearchRegexForEngine:(SearchEngine)engine;


-(NSArray*)arrayOfSearchRegex;
@end
