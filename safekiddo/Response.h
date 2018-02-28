//
//  Response.h
//  safekiddo
//
//  Created by Jakub Dlugosz on 04.11.2014.
//  Copyright (c) 2014 ardura. All rights reserved.
//

#import "JSONModel.h"

/**
 *  Basic API Response
 */
@interface Response : JSONModel

/**
 *  Flag indicating a succesfull operation
 */
@property(strong,nonatomic) NSNumber* success;

@end
