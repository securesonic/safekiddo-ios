//
//  NetworkConstants.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 18.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "NetworkConstants.h"

#if defined(DEV)
NSString* const kBaseURLPath = @"https://dev-api.safekiddo.com/api/v1/";
NSString* const kBaseURLPathV2 = @"https://dev-api.safekiddo.com/api/v2/";
NSString* const kMDMBaseURLPath = @"http://dev-ws.safekiddo.com/";
#elif defined(TEST)
NSString* const kBaseURLPath = @"https://tst-api.safekiddo.com/api/v1/";
NSString* const kMDMBaseURLPath = @"http://tst-ws.safekiddo.com/";
#elif defined(PROD)
NSString* const kBaseURLPath = @"https://api.safekiddo.com/api/v1/";
NSString* const kBaseURLPathV2 = @"https://api.safekiddo.com/api/v2/";
NSString* const kMDMBaseURLPath = @"http://ws.safekiddo.com:80/";
#endif

NSString* const kUserAgent = @"SafeKiddo Mobile (%@; iOS %@; https://safekiddo.com)";


NSString* const kLoginRequest = @"login";
NSString* const kLogoutRequest = @"logout";

NSString* const kChildsRequest = @"childs";
NSString* const kChildSetRequest = @"child/set";

NSString* const kHomePageRequest = @"home_page";
NSString* const kBlockRequest = @"block";

NSString* const kChildCheckRequest = @"cc";

NSString* const kHeartBeatRequest = @"device/%@/hb";

NSString* const kUsernameParam = @"username";
NSString* const kPasswordParam = @"password";

NSString* const kChildUUIDParam = @"child_uuid";
NSString* const kDeviceUUIDParam = @"device_uuid";
NSString* const kDeviceLabelParam = @"device_label";

NSString* const kSKCodeParam = @"sk-code";
NSString* const kSKURLParam = @"sk-url";

NSString* const kUserActionParam = @"UserAction";
NSString* const kRequestParam = @"Request";
NSString* const kUserIdParam = @"UserId";

NSString* const kRegisterRequest = @"user/register";

NSString* const kRegisterEmailParam = @"email";
NSString* const kRegisterFirstNameParam = @"first_name";
NSString* const kRegisterLastNameParam = @"last_name";
NSString* const kRegisterPasswordParam = @"password";
NSString* const kRegisterPINParam = @"pin";
NSString* const kRegisterProfileNameParam= @"profile_name";
NSString* const kRegisterProfileBirthYearParam = @"profile_birth_year";
NSString* const kRegisterTimeZoneParam = @"timezone";
NSString* const kRegisterLangParam = @"lang";
NSString* const kRegisterInternetUsageTimeParam = @"internet_usage_time";
NSString* const kRegisterDeviceUsageTimeParam = @"device_usage_time";
NSString* const kRegisterShareDataParam = @"share_data";

NSString* const kSetSettingsRequestFormat = @"device/%@/settings";
NSString* const kSettingsPushTokenParam = @"push_token";


