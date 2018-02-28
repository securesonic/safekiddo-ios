//
//  RegisterRequestData.m
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import "RegisterRequestData.h"
#import "NetworkConstants.h"
#import "TimeSpan.h"
@implementation RegisterRequestData

-(instancetype)init
{

    self.timeZone =     [NSTimeZone localTimeZone];
    self.languageCode = [[NSLocale preferredLanguages]objectAtIndex:0];
    return [super init];
}

-(void)populateInternetUsageTimeWithWeekStart:(NSDate*)weekStart weekEnd:(NSDate*)weekEnd weekendStart:(NSDate*)weekendStart weekendEnd:(NSDate*)weekendEnd
{
    NSMutableArray* array = [NSMutableArray array];
    
    for(int i=0;i<5/*mon-fri*/;i++)
    {
        [array addObject:[TimeSpan timeSpaneWithStartDate:weekStart endDate:weekEnd]];
    }
    
    for(int i=0;i<2;i++)
    {
        [array addObject:[TimeSpan timeSpaneWithStartDate:weekendStart endDate:weekendEnd]];
    }
    
    self.internetUsageTime = [array copy];
}

-(NSDictionary*)requestParamters
{
    NSMutableDictionary* requestDictionary = [NSMutableDictionary new];
    
    [requestDictionary setObject:[self.email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterEmailParam];
    [requestDictionary setObject:[self.firstName  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterFirstNameParam];
    
    if(self.lastName)
    {
        [requestDictionary setObject:[self.lastName  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterLastNameParam];
    }
    
    [requestDictionary setObject:[self.password  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterPasswordParam];
    [requestDictionary setObject:[self.pin  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterPINParam];
    [requestDictionary setObject:[self.profileName  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterProfileNameParam];
    [requestDictionary setObject:@(self.profileBirthYear)  forKey:kRegisterProfileBirthYearParam];
    if(self.timeZone)
    {
        [requestDictionary setObject:[self.timeZone.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterTimeZoneParam];
    }
    [requestDictionary setObject:[self.languageCode  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterLangParam];
    
    
    if(self.internetUsageTime)
    {
        NSMutableArray* array=  [NSMutableArray new];
        for(TimeSpan* ts in self.internetUsageTime)
        {
            [array addObject:[ts toDictionary]];
        }
        
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:array options:0 error:nil];
        NSString* jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        
        [requestDictionary setObject:[jsonString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:kRegisterInternetUsageTimeParam];

    }
    
    if(self.shareData)
    {
        [requestDictionary setObject:@"true" forKey:kRegisterShareDataParam];
    }
    else
    {
        [requestDictionary setObject:@"false" forKey:kRegisterShareDataParam];
    }
    
    return [requestDictionary copy];
}


-(BOOL)validateEmail
{
    if(self.email)
    {
        NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
        
        return [emailTest evaluateWithObject:self.email];
    }
    else
    {
        return NO;
    }
}

-(BOOL)validateFirstName
{
    return self.firstName.length >= 1;
}

-(BOOL)validatePassword
{
    if(self.password)
    {
        return self.password.length >= 6;
    }
    else
    {
        return NO;
    }
}

-(BOOL)validatePin
{
    return  self.pin.length >= 4 && self.pin.length <= 8;
}

-(BOOL)validateProfileName
{
    return self.profileName.length >= 1;
}

-(BOOL)validateBirthYear
{
    int currentYear = [[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (self.profileBirthYear >= currentYear-18);
}



@end
