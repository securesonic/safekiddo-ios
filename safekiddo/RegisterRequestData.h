//
//  RegisterRequestData.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 19.03.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterRequestData : NSObject

@property(strong,nonatomic)NSString* email;
@property(strong,nonatomic)NSString* firstName;
@property(strong,nonatomic)NSString* lastName;
@property(strong,nonatomic)NSString* password;
@property(strong,nonatomic)NSString* pin;
@property(strong,nonatomic)NSString* profileName;
@property(assign,nonatomic)NSInteger profileBirthYear;
@property(strong,nonatomic)NSTimeZone* timeZone;
@property(strong,nonatomic)NSString* languageCode;
@property(strong,nonatomic)NSArray* internetUsageTime;
@property(assign,nonatomic)BOOL shareData;

-(void)populateInternetUsageTimeWithWeekStart:(NSDate*)weekStart weekEnd:(NSDate*)weekEnd weekendStart:(NSDate*)weekendStart weekendEnd:(NSDate*)weekendEnd;


-(NSDictionary*)requestParamters;

-(BOOL)validateEmail;
-(BOOL)validateFirstName;
-(BOOL)validatePassword;
-(BOOL)validatePin;
-(BOOL)validateProfileName;
-(BOOL)validateBirthYear;


@end


