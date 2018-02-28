//
//  PairChildResponse.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 16.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "Response.h"

@interface PairChildResponse : Response

@property(strong,nonatomic) NSString* deviceUuid;
@property(strong,nonatomic) NSString<Optional>* mdmMail;

@end
