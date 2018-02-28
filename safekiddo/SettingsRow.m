//
//  SettingsRow.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.12.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "SettingsRow.h"

@implementation SettingsRow

+(SettingsRow*)rowWithType:(SettingsEnum)type
{
    SettingsRow* row = [SettingsRow new];
    row.type = type;
    return row;
}

-(NSString *)title
{
    switch (self.type)
    {
        case SettingsBrowserIdentity:
            return NSLocalizedString(@"SETTINGS_BROWSER_IDENTITY", @"");
            break;
        case SettingsBrowserParentMode:
            return NSLocalizedString(@"SETTINGS_PARENT_MODE", @"");
            break;
        case SettingsClearBrowserHistory:
            return NSLocalizedString(@"SETTINGS_CLEAR_BROWSER_HISTORY", @"");
            break;
        case SettingsClearCache:
            return NSLocalizedString(@"SETTINGS_CLEAR_CACHE", @"");
            break;
        case SettingsCookieClear:
            return NSLocalizedString(@"SETTINGS_COOKIE_CLEAR", @"");
            break;
            case SettingsOpenSource:
            return NSLocalizedString(@"SETTINGS_OPENSOURCE", @"");
            break;
        case SettingsCopyright:
            return NSLocalizedString(@"SETTINGS_COPYRIGHT", @"");
            break;
        case SettingsCookiesPolicy:
            return NSLocalizedString(@"SETTINGS_COOKIES", @"");
            break;
        case SettingsPrivacyPolicy:
            return NSLocalizedString(@"SETTINGS_PRIVACY", @"");
            break;
        case SettingsRegulations:
            return NSLocalizedString(@"SETTINGS_REGULATIONS", @"");
            break;
        case SettingsLogout:
            return NSLocalizedString(@"SETTINGS_LOGOUT", @"");
            break;
        case SettingsAssingAcount:
            return NSLocalizedString(@"SETTINGS_ASSING_ACCOUNT", @"");
            break;
        case SettingsVersion:
            return [NSString stringWithFormat:NSLocalizedString(@"SETTINGS_VERSION", @""),[[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"]];
            break;
        case SettingsEnableSettings:
            return NSLocalizedString(@"SETTINGS_ENABLE_SETTINGS", @"");
            break;
        case SettingsUnlockAppStore:
            return NSLocalizedString(@"SETTINGS_UNLOCK_APP_STORE", @"");
            break;
        case SettingsManageSafeKiddo:
            return NSLocalizedString(@"SETTINGS_MANAGE_SAFE_KIDDO", @"");
            break;
        case SettingsAbout:
            return NSLocalizedString(@"SETTINGS_ABOUT", @"");
            break;
        case SettingsTermsAndConditions:
            return NSLocalizedString(@"SETTINGS_TERMS_AND_CONDITIONS", @"");
            break;
        case SettingsSearchEngine:
            return NSLocalizedString(@"SETTINGS_SEARCH_ENGINE", @"");
    }
}

@end
