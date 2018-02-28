

//
//  LoginResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "JSONModel.h"
#import "Response.h"
/**
 *  Response to a Login request
 */
@interface LoginResponse : Response



/**
 *  Users pin - returned if operation was succesfull
 */
@property(strong,nonatomic) NSString<Optional>* pin;
@property(strong,nonatomic) NSString<Optional>* pin_ios;

@end
