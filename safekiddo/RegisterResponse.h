//
//  RegisterResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 13.06.2015.
//  Copyright (c) 2015 ardura. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"
@interface RegisterResponse : Response





@property(strong,nonatomic) NSString<Optional>* message;
@property(strong,nonatomic) NSString<Ignore>* deviceEndTime;
@property(strong,nonatomic) NSString<Ignore>* deviceStartTime;
@property(strong,nonatomic) NSString<Ignore>* internetStartTime;
@property(strong,nonatomic) NSString<Ignore>* internetEndTime;
@property(strong,nonatomic) NSString<Ignore>* deviceDuration;



@end
